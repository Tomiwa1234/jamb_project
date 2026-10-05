import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../services/auth_service.dart';
import 'exam_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.auth});

  final AuthService auth;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<String> _years = ({
    for (final s in questionBank.values) ...s.keys,
  }.toList()..sort((a, b) => b.compareTo(a)));
  late String _year = _years.first;
  final Set<String> _selected = {};
  int _minutes = 15;
  ExamMode _mode = ExamMode.exam;

  List<String> get _available => questionBank.entries
      .where((e) => e.value.containsKey(_year))
      .map((e) => e.key)
      .toList();

  @override
  void initState() {
    super.initState();
    _selected.addAll(_available.take(4));
  }

  void _pickYear(String y) => setState(() {
    _year = y;
    _selected
      ..clear()
      ..addAll(_available.take(4));
  });

  void _toggleSubject(String s, bool on) {
    if (on && _selected.length >= 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can pick up to 4 subjects.')),
      );
      return;
    }
    setState(() => on ? _selected.add(s) : _selected.remove(s));
  }

  void _start() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick at least one subject.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamScreen(
          auth: widget.auth,
          year: _year,
          subjects: _available.where(_selected.contains).toList(),
          minutes: _minutes,
          mode: _mode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.auth.currentUser!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('JAMB CBT Practice'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(auth: widget.auth),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: widget.auth.logout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(
                'Welcome, ${user.name.split(' ').first}',
                style: theme.textTheme.titleLarge,
              ),
              subtitle: Text(
                'High score: ${user.highScore}%  ·  Tests taken: ${user.attempts.length}',
              ),
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
            ),
          ),
          const SizedBox(height: 12),
          Text('Select year', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final y in _years)
                ChoiceChip(
                  label: Text(
                    user.bestForYear(y) > 0
                        ? '$y · best ${user.bestForYear(y)}%'
                        : y,
                  ),
                  selected: y == _year,
                  onSelected: (_) => _pickYear(y),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Subjects (up to 4)', style: theme.textTheme.titleMedium),
          for (final s in _available)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s),
              subtitle: Text('${questionBank[s]![_year]!.length} questions'),
              value: _selected.contains(s),
              onChanged: (v) => _toggleSubject(s, v ?? false),
            ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _minutes,
            decoration: const InputDecoration(
              labelText: 'Time (minutes)',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final m in [5, 15, 30, 60, 120])
                DropdownMenuItem(value: m, child: Text('$m')),
            ],
            onChanged: (v) => setState(() => _minutes = v ?? 15),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ExamMode>(
            initialValue: _mode,
            decoration: const InputDecoration(
              labelText: 'Mode',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: ExamMode.exam,
                child: Text('Exam: answers shown at the end'),
              ),
              DropdownMenuItem(
                value: ExamMode.study,
                child: Text('Study: check each answer instantly'),
              ),
            ],
            onChanged: (v) => setState(() => _mode = v ?? ExamMode.exam),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _start,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start practice'),
          ),
        ],
      ),
    );
  }
}
