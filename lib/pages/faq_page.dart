import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  static final _faq = <Map<String, String>>[
    {
      'q': 'Where is my data stored?',
      'a':
          'Inside a small encrypted database on your phone. Nothing leaves your device.',
    },
    {
      'q': 'Can I edit past days?',
      'a': 'Yes. Tap the date at the top, pick any day, and update its lists.',
    },
    {
      'q': 'What if I delete an item by mistake?',
      'a':
          'Swipe-to-delete has no undo, so swipe mindfully. Export/backup is on the roadmap.',
    },
    {
      'q': 'Will you add reminders?',
      'a':
          'Probably. Let me know if gentle nightly notifications would help you.',
    },
    {
      'q': 'Is this app only for people in recovery?',
      'a':
          'No. Anyone who wants a quick daily moral inventory can benefit—students, parents, leaders, you name it.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _faq.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder:
            (_, i) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _faq[i]['q']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_faq[i]['a']!, style: const TextStyle(fontSize: 16)),
              ],
            ),
      ),
    );
  }
}
