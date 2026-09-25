import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int amount;
  final int categoryId;
  final String difficulty;
  final String type;
  final String userName;

  const QuizScreen({
    super.key,
    required this.amount,
    required this.categoryId,
    required this.difficulty,
    required this.type,
    required this.userName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<QuestionModel>> _questionsFuture;
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = ApiService.fetchQuestions(
      amount: widget.amount,
      categoryId: widget.categoryId,
      difficulty: widget.difficulty,
      type: widget.type,
    );
  }

  void _onOptionSelected(String option, QuestionModel question) {
    if (_isAnswered) return; // Prevent changing answer
    setState(() {
      _selectedOption = option;
      _isAnswered = true;
      if (option == question.correctAnswer) {
        _score++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<QuestionModel>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No questions found for these settings.'));
            }

            final questions = snapshot.data!;
            final currentQuestion = questions[_currentIndex];

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_currentIndex + 1}/${questions.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.exit_to_app, color: Colors.grey),
                        label: const Text('EXIT', style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / questions.length,
                    color: const Color(0xFF005F56),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(currentQuestion.question,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        final option = currentQuestion.options[index];
                        Color color = Colors.white;

                        // Highlight green for correct, red for incorrect selection
                        if (_isAnswered) {
                          if (option == currentQuestion.correctAnswer) {
                            color = Colors.green.shade100;
                          } else if (option == _selectedOption) {
                            color = Colors.red.shade100;
                          }
                        }

                        return GestureDetector(
                          onTap: () => _onOptionSelected(option, currentQuestion),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(option),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005F56)),
                      onPressed: !_isAnswered
                          ? null
                          : () {
                              if (_currentIndex + 1 < questions.length) {
                                setState(() {
                                  _currentIndex++;
                                  _selectedOption = null;
                                  _isAnswered = false;
                                });
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ResultScreen(
                                      score: _score,
                                      totalQuestions: questions.length,
                                      userName: widget.userName,
                                    ),
                                  ),
                                );
                              }
                            },
                      child: Text(
                        _currentIndex + 1 == questions.length ? 'FINISH' : 'Next',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}