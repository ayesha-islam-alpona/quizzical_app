import 'package:flutter/material.dart';
import 'categories_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String userName;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / totalQuestions) * 100;
    final bool isPassed = percentage >= 50;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                isPassed ? Icons.celebration : Icons.sentiment_dissatisfied,
                size: 90,
                color: isPassed ? Colors.amber : Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                isPassed ? 'Congratulation' : 'Keep Trying!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                decoration: BoxDecoration(
                  color: isPassed ? Colors.teal.shade100 : Colors.deepOrange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${percentage.toInt()}%',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005F56)),
                  onPressed: () {
                    // Navigate back to categories screen and clear previous stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoriesScreen(userName: userName),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('PLAY AGAIN', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}