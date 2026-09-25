import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'categories_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final int score = provider.score;
    final int total = provider.questions.length;
    final double accuracy = total > 0 ? (score / total) * 100 : 0;
    final bool isPassed = accuracy >= 50;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                isPassed
                    ? 'assets/images/congratulation.png'
                    : 'assets/images/keep_trying.png',
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    isPassed ? Icons.celebration : Icons.sentiment_dissatisfied,
                    size: 100,
                    color: isPassed ? Colors.amber : Colors.orangeAccent,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                isPassed ? 'Congratulation!' : 'Keep Trying!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'You scored $score/$total!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatTile(
                    title: 'Accuracy',
                    value: '${accuracy.toInt()}%',
                    color: isPassed ? const Color(0xFF004D40) : const Color(0xFFBF360C),
                    bgColor: isPassed ? const Color(0xFFB2DFDB) : const Color(0xFFFFCCBC),
                  ),
                  _StatTile(
                    title: 'Total Time',
                    value: '${provider.totalTimeInSeconds}s',
                    color: const Color(0xFF1E3A8A),
                    bgColor: const Color(0xFFDBEAFE),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005F56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    provider.resetQuiz();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoriesScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Play Again',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color bgColor;

  const _StatTile({
    required this.title,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}