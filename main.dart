import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeReachYouApp());
}

class WeReachYouApp extends StatelessWidget {
  const WeReachYouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نصل إليك',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050509),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700), // ذهبي
          secondary: Color(0xFFEEEEEE), // أبيض معدني
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_rounded,
              color: const Color(0xFFFFD700),
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'نصل إليك',
              style: GoogleFonts.cairo(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تطبيق محادثة حديث مثل ويتشات',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
