import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
