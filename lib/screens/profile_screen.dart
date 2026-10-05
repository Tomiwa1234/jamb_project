import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.auth});

  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    final u = auth.currentUser!;
    final theme = Theme.of(context);
    final years = ({for (final s in questionBank.values) ...s.keys}.toList()
      ..sort((a, b) => b.compareTo(a)));
    final recent = u.attempts.reversed.take(20).toList();

    Widget stat(String label, String value) => Expanded(
      child: Card(
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: Text(
                  u.name.isEmpty ? '?' : u.name[0].toUpperCase(),
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name, style: theme.textTheme.titleLarge),
                    Text(
                      '@${u.username}'
                      '${u.email.isEmpty ? '' : ' · ${u.email}'}',
                    ),
                    Text(
                      'Joined ${u.joined.day}/${u.joined.month}/${u.joined.year}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              stat('High score', '${u.highScore}%'),
              stat('Average', '${u.average}%'),
              stat('Tests', '${u.attempts.length}'),
            ],
          ),
          const SizedBox(height: 8),
          Text('High score by year', style: theme.textTheme.titleMedium),
          for (final y in years)
            ListTile(
              dense: true,
              title: Text(y),
              trailing: Text(
                u.bestForYear(y) > 0 ? '${u.bestForYear(y)}%' : '—',
              ),
            ),
          const SizedBox(height: 8),
          Text('Recent attempts', style: theme.textTheme.titleMedium),
          if (recent.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No attempts yet. Start practising!'),
            ),
          for (final a in recent)
            ListTile(
              dense: true,
              title: Text('${a.year} · ${a.subjects.join(', ')}'),
              subtitle: Text(
                '${a.date.day}/${a.date.month}/${a.date.year} ${a.date.hour.toString().padLeft(2, '0')}:${a.date.minute.toString().padLeft(2, '0')}',
              ),
              trailing: Text('${a.score}/${a.total} (${a.percent}%)'),
            ),
        ],
      ),
    );
  }
}
