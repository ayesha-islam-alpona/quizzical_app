import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class ConfigScreen extends StatelessWidget {
  final CategoryModel category;

  const ConfigScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzical'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/config_header.png',
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.tune, size: 80, color: Color(0xFF005F56));
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Configuration\n${category.name}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Number of Questions'),
                    Text('${provider.amount}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: provider.amount.toDouble(),
                  min: 1,
                  max: 50,
                  divisions: 49,
                  activeColor: const Color(0xFF005F56),
                  label: '${provider.amount}',
                  onChanged: (val) {
                    provider.updateConfig(amount: val.toInt());
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: provider.difficulty,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty Level',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'any', child: Text('Any Difficulty')),
                    DropdownMenuItem(value: 'easy', child: Text('Easy')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'hard', child: Text('Hard')),
                  ],
                  onChanged: (val) {
                    if (val != null) provider.updateConfig(difficulty: val);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: provider.type,
                  decoration: const InputDecoration(
                    labelText: 'Question Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'any', child: Text('Any Type')),
                    DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice')),
                    DropdownMenuItem(value: 'boolean', child: Text('True / False')),
                  ],
                  onChanged: (val) {
                    if (val != null) provider.updateConfig(type: val);
                  },
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
                      provider.startQuiz(category.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuizScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'START',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}