import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // ────────────────────────────────────────────────────────────────
  // 1.  Long-form copy in a raw multi-line string.
  //     Using triple quotes lets you keep nice paragraphs.
  // ────────────────────────────────────────────────────────────────
  static const String _aboutText = '''
I’m Kim—the lone developer behind this little app.

For years I wrestled with addiction and alcoholism. After countless false
starts, months locked inside institutions, and broken promises; I finally surrendered to my disease and embraced whatever solution that comes. The 12-Step Program has worked for me. The program didn’t just teach me how to stop
drinking and using—it gave me a *spiritual tool-kit for living*.

One tool shines above the rest for day-to-day sanity:

**Step Ten**
> *“Continued to take personal inventory and when we were wrong promptly admitted it.”*

Every night I jot two quick lists:

* **GOOD** – moments I acted with honesty, service, courage, or kindness.
* **BAD**  – slip-ups, selfish motives, shortcuts, unkind words—anything that
  blocks me from peace.

This nightly balance-sheet keeps my ego right-sized, shows patterns, and lets
me start tomorrow clean.

**Daily Balance** is simply my battered notebook turned into an app.

> *We are not saints; we seek progress, not perfection.
> …and progress begins with an honest inventory.*

Keep coming back,
*Kim* ☀️🌑
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About This App')),
      body: SafeArea(
        child: SingleChildScrollView(
          // handles long text on small phones
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Story & purpose ───────────────────────────────
              MarkdownBody(
                data: _aboutText,
                selectable: true, // user can long-press & copy
                styleSheet: MarkdownStyleSheet.fromTheme(
                  Theme.of(context),
                ).copyWith(
                  // body & headings sizing
                  p: const TextStyle(fontSize: 16, height: 1.45),
                  h2: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  h3: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                  // block-quote tweaks
                  blockquote: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  blockquotePadding: const EdgeInsets.all(12),
                  blockquoteDecoration: BoxDecoration(
                    color: Colors.grey.shade200, // soft grey background
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ─── Coffee link ───────────────────────────────────
              const Text(
                'Buy me a coffee ☕',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                icon: const FaIcon(FontAwesomeIcons.paypal),
                label: const Text('Send your donation via Paypal'),
                onPressed:
                    () => launchUrl(
                      Uri.parse(
                        'https://paypal.me/kimcorros?country.x=PH&locale.x=en_US',
                      ),
                      mode: LaunchMode.externalApplication,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
