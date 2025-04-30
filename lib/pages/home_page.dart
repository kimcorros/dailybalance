// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../model/daily_entry.dart';
import '../pages/about_page.dart';
import '../pages/faq_page.dart';
import '../widgets/entry_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box box = Hive.box('entries');
  DateTime _selected = DateTime.now();

  // ───────────────────────────────── helpers
  DailyEntry _entryFor(DateTime d) {
    final key = DateFormat('yyyy-MM-dd').format(d);
    final stored = box.get(key);
    return stored == null
        ? DailyEntry(good: [], bad: [])
        : DailyEntry.fromMap(stored);
  }

  void _save(DateTime d, DailyEntry entry) {
    final key = DateFormat('yyyy-MM-dd').format(d);
    box.put(key, entry.toMap());
  }

  // keep the switch-case tidy
  Future<void> _handleMenu(int value) async {
    switch (value) {
      case 0: // reset
        final ok = await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Delete ALL entries?'),
                content: const Text('This cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        );
        if (ok ?? false) {
          await box.clear();
          setState(() {});
        }
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutPage()),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FAQPage()),
        );
        break;
    }
  }

  // ──────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final entry = _entryFor(_selected);

    // themed popup menu (style only)
    final PopupMenuThemeData menuTheme = PopupMenuThemeData(
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      elevation: 6,
    );

    return PopupMenuTheme(
      data: menuTheme,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 150, // room for icon + date
          leading: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 8),
              shape: const RoundedRectangleBorder(),
            ),
            icon: const Icon(
              Icons.calendar_today,
              size: 18,
              color: Colors.black,
            ),
            label: Text(
              DateFormat('MMM d, yyyy').format(_selected), // Apr 30, 2025
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selected,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _selected = picked);
            },
          ),

          // centered logo
          title: Image.asset('assets/logo.png', height: 32),
          centerTitle: true,

          // right-hand burger
          actions: [
            SizedBox(
              width: 60,
              child: PopupMenuButton<int>(
                splashRadius: 24,
                icon: const Icon(Icons.menu, color: Colors.black87),
                onSelected: _handleMenu,
                itemBuilder:
                    (_) => const [
                      PopupMenuItem(
                        value: 0,
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.delete_outline),
                          title: Text('Reset Data'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.info_outline),
                          title: Text('About This App'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.help_outline),
                          title: Text('FAQ'),
                        ),
                      ),
                    ],
              ),
            ),
          ],
        ),

        // ─── Main body: good / bad halves ───────────────────────
        body: Column(
          children: [
            Expanded(
              child: EntryPanel(
                title: 'GOOD',
                entryList: entry.good,
                bg: Colors.white,
                fg: Colors.black,
                onChanged: (list) {
                  entry.good = list;
                  _save(_selected, entry);
                },
              ),
            ),
            Expanded(
              child: EntryPanel(
                title: 'BAD',
                entryList: entry.bad,
                bg: Colors.black,
                fg: Colors.white,
                onChanged: (list) {
                  entry.bad = list;
                  _save(_selected, entry);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
