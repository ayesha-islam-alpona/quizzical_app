import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingQuestions) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.questionError != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Error: ${provider.questionError}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to Config'),
                    ),
                  ],
                ),
              );
            }

            if (provider.questions.isEmpty) {
              return const Center(child: Text('No questions found for this selection.'));
            }

            final currentQuestion = provider.questions[provider.currentIndex];

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${provider.currentIndex + 1}/${provider.questions.length}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${provider.timeLeft}s',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          provider.resetQuiz();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.exit_to_app, color: Colors.grey),
                        label: const Text('EXIT', style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (provider.currentIndex + 1) / provider.questions.length,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFF005F56),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      currentQuestion.question,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final option = currentQuestion.options[index];
                        Color cardColor = Colors.white;
                        IconData icon = Icons.circle_outlined;
                        Color iconColor = Colors.grey;

                        if (provider.isAnswered) {
                          if (option == currentQuestion.correctAnswer) {
                            cardColor = const Color(0xFFD4EDDA);
                            icon = Icons.check_circle;
                            iconColor = Colors.green;
                          } else if (option == provider.selectedOption) {
                            cardColor = const Color(0xFFF8D7DA);
                            icon = Icons.cancel;
                            iconColor = Colors.red;
                          }
                        }

                        return GestureDetector(
                          onTap: () => provider.selectOption(option),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: provider.selectedOption == option
                                    ? Colors.teal
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(option, style: const TextStyle(fontSize: 14)),
                                ),
                                Icon(icon, color: iconColor),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                      onPressed: !provider.isAnswered
                          ? null
                          : () {
                              final isFinished = provider.nextQuestion();
                              if (isFinished) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ResultScreen(),
                                  ),
                                );
                              }
                            },
                      child: Text(
                        provider.currentIndex + 1 == provider.questions.length
                            ? 'FINISH'
                            : 'NEXT',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}