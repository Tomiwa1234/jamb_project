import 'dart:async';

import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../models/question.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum ExamMode { exam, study }

class ExamScreen extends StatefulWidget {
  const ExamScreen({
    super.key,
    required this.auth,
    required this.year,
    required this.subjects,
    required this.minutes,
    required this.mode,
  });

  final AuthService auth;
  final String year;
  final List<String> subjects;
  final int minutes;
  final ExamMode mode;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  static const _letters = 'ABCDE';

  late String _subject = widget.subjects.first;
  int _index = 0;
  final Map<String, int> _answers = {};
  final Set<String> _flagged = {};
  final Set<String> _checked = {};
  late final DateTime _end = DateTime.now().add(
    Duration(minutes: widget.minutes),
  );
  Duration _left = Duration.zero;
  Timer? _timer;
  bool _done = false;
  bool _showResult = false;
  int _score = 0;
  int _total = 0;
  bool _isBest = false;

  List<Question> _qs(String s) => questionBank[s]![widget.year]!;
  String _key(String s, int i) => '$s|$i';

  @override
  void initState() {
    super.initState();
    _left = Duration(minutes: widget.minutes);
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_done) return;
      final left = _end.difference(DateTime.now());
      if (left <= Duration.zero) {
        _finish();
      } else {
        setState(() => _left = left);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_done) return;
    _timer?.cancel();
    var score = 0, total = 0;
    for (final s in widget.subjects) {
      final qs = _qs(s);
      total += qs.length;
      for (var i = 0; i < qs.length; i++) {
        if (_answers[_key(s, i)] == qs[i].answer) score++;
      }
    }
    final user = widget.auth.currentUser!;
    final attempt = Attempt(
      date: DateTime.now(),
      year: widget.year,
      subjects: widget.subjects,
      score: score,
      total: total,
    );
    final previousBest = user.highScore;
    setState(() {
      _done = true;
      _showResult = true;
      _score = score;
      _total = total;
      _isBest = attempt.percent > 0 && attempt.percent >= previousBest;
    });
    await widget.auth.addAttempt(attempt);
  }

  Future<bool> _confirmSubmit() async {
    final answered = _answers.length;
    final total = widget.subjects.fold<int>(0, (n, s) => n + _qs(s).length);
    return await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Submit test?'),
            content: Text('You answered $answered of $total questions.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Keep going'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('Submit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _confirmExit() async =>
      await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Leave test?'),
          content: const Text('Your progress will be lost and not scored.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Stay'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Leave'),
            ),
          ],
        ),
      ) ??
      false;

  String get _clock {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(_left.inMinutes)}:${two(_left.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _done,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _confirmExit();
        if (leave && context.mounted) Navigator.pop(context);
      },
      child: _showResult ? _buildResult(context) : _buildExam(context),
    );
  }

  Widget _buildResult(BuildContext context) {
    final theme = Theme.of(context);
    final pct = _total == 0 ? 0 : (_score * 100 / _total).round();
    return Scaffold(
      appBar: AppBar(title: Text('JAMB ${widget.year} result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '$_score / $_total',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('$pct%', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    _isBest
                        ? '\u{1F3C6} This is your high score!'
                        : 'Your high score: ${widget.auth.currentUser!.highScore}%',
                  ),
                ],
              ),
            ),
          ),
          for (final s in widget.subjects)
            ListTile(
              title: Text(s),
              trailing: Text(
                '${[for (var i = 0; i < _qs(s).length; i++)
                  if (_answers[_key(s, i)] == _qs(s)[i].answer) 1].length} / ${_qs(s).length}',
              ),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => setState(() {
              _showResult = false;
              _subject = widget.subjects.first;
              _index = 0;
            }),
            child: const Text('Review corrections'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('New practice'),
          ),
        ],
      ),
    );
  }

  Widget _buildExam(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final qs = _qs(_subject);
    final q = qs[_index];
    final k = _key(_subject, _index);
    final picked = _answers[k];
    final reveal =
        _done || (widget.mode == ExamMode.study && _checked.contains(k));

    Color? tileColor(int i) {
      if (reveal) {
        if (i == q.answer) return scheme.primaryContainer;
        if (i == picked) return scheme.errorContainer;
        return null;
      }
      return i == picked ? scheme.secondaryContainer : null;
    }

    final palette = Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < qs.length; i++)
          InkWell(
            onTap: () => setState(() => _index = i),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _answers.containsKey(_key(_subject, i))
                    ? scheme.primary
                    : null,
                border: Border.all(
                  color: i == _index ? scheme.onSurface : scheme.outline,
                  width: i == _index ? 3 : 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: _answers.containsKey(_key(_subject, i))
                          ? scheme.onPrimary
                          : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_flagged.contains(_key(_subject, i)))
                    const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ColoredBox(
                        color: Colors.orange,
                        child: SizedBox(height: 4),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('JAMB ${widget.year}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _done ? 'Review' : _clock,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_done)
            TextButton(
              onPressed: () => setState(() => _showResult = true),
              child: const Text('Results'),
            )
          else
            TextButton(
              onPressed: () async {
                if (await _confirmSubmit()) await _finish();
              },
              child: const Text('Submit'),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                for (final s in widget.subjects)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(s),
                      selected: s == _subject,
                      onSelected: (_) => setState(() {
                        _subject = s;
                        _index = 0;
                      }),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Question ${_index + 1} of ${qs.length}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(q.text, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          for (var i = 0; i < q.options.length; i++)
            Card(
              color: tileColor(i),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 15,
                  child: Text(
                    _letters[i],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(q.options[i]),
                enabled: !_done && !reveal,
                onTap: () => setState(() => _answers[k] = i),
              ),
            ),
          if (reveal)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Answer: ${_letters[q.answer]}. ${q.explanation}'),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: _index == 0 ? null : () => setState(() => _index--),
                child: const Text('Previous'),
              ),
              FilledButton(
                onPressed: _index == qs.length - 1
                    ? null
                    : () => setState(() => _index++),
                child: const Text('Next'),
              ),
              if (!_done)
                OutlinedButton.icon(
                  onPressed: () => setState(
                    () => _flagged.contains(k)
                        ? _flagged.remove(k)
                        : _flagged.add(k),
                  ),
                  icon: Icon(
                    _flagged.contains(k) ? Icons.flag : Icons.outlined_flag,
                  ),
                  label: Text(_flagged.contains(k) ? 'Flagged' : 'Flag'),
                ),
              if (!_done && widget.mode == ExamMode.study)
                OutlinedButton(
                  onPressed: picked == null
                      ? null
                      : () => setState(() => _checked.add(k)),
                  child: const Text('Check answer'),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Question palette', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          palette,
        ],
      ),
    );
  }
}
