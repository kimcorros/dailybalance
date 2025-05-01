import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await Hive.openBox('entries');
  FlutterNativeSplash.remove();
  runApp(const DailyBalanceApp());
}

class DailyBalanceApp extends StatelessWidget {
  const DailyBalanceApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Balance',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});
  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  late final String quote;
  final quotes = [
    // 30 bite-sized prompts for nightly inventory & steady growth
    'Progress, not perfection, is still progress.',
    'A small act of honesty outweighs a grand excuse.',
    'The day isn’t over until you’ve learned from it.',
    'Courage is a series of tiny “yes, I will try again.”',
    'Mistakes lose their power the moment you own them.',
    'Gratitude turns what we did into what we’ve gained.',
    'Kindness you forget is still remembered by others.',
    'When ego whispers, let humility answer.',
    'Every admission of wrong makes room for a right.',
    'Growth hides in the questions we’re afraid to ask.',
    'You can’t change the past, but you can edit tomorrow’s script.',
    'A clear conscience sleeps deeper than a full wallet.',
    'Service is the rent we pay for living another sober day.',
    'Character is built in the unseen moments.',
    'Forgive yourself—then prove it with action.',
    'If it cost you your peace, it was too expensive.',
    'One honest sentence can heal a day of denial.',
    'Your best apology is changed behaviour.',
    'Small disciplines repeated daily build unshakeable trust.',
    'Listen to the quiet voice before the loud regret.',
    'A day well examined is a day well invested.',
    'Inventory isn’t judgment; it’s quality control.',
    'The lesson repeats until the behaviour changes.',
    'Peace is the prize for promptly admitting wrong.',
    'Tiny acts of courage compound into big self-respect.',
    'Your future self is reading today’s entry—write kindly.',
    'Humility is the door; willingness is the key.',
    'Plant one good seed; pull one bad weed—every day.',
    'Honesty may be uncomfortable, but it’s never heavy.',
    'Finish the day lighter: keep the good, release the bad.',
  ];

  @override
  void initState() {
    super.initState();
    quote = (quotes..shuffle()).first; // pick a random one
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // center whole column
            children: [
              SizedBox(
                width: 120, // tweak to taste
                height: 120,
                child: Image.asset(
                  'assets/logo.png', // same file you used for splash/icon
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32), // spacer between logo & quote

              Text(
                '"$quote"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
