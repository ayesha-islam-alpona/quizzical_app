import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: const QuizzicalApp(),
    ),
  );
}

class QuizzicalApp extends StatelessWidget {
  const QuizzicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzical',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primaryColor: const Color(0xFF005F56),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005F56)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}