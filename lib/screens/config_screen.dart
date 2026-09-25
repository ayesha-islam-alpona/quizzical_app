import 'package:flutter/material.dart';
import '../models/category_model.dart';
import 'quiz_screen.dart';

class ConfigScreen extends StatefulWidget {
  final CategoryModel category;
  final String userName;

  const ConfigScreen({super.key, required this.category, required this.userName});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  double _questionCount = 10;
  String _difficulty = 'any';
  String _type = 'multiple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quizzical'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.settings, size: 70, color: Color(0xFF005F56)),
            const SizedBox(height: 8),
            Text('Configuration\n${widget.category.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            // Slider for question count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of Questions'),
                Text('${_questionCount.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _questionCount,
              min: 5,
              max: 20,
              divisions: 15,
              activeColor: const Color(0xFF005F56),
              onChanged: (val) => setState(() => _questionCount = val),
            ),
            const SizedBox(height: 16),

            // Dropdown for difficulty
            DropdownButtonFormField<String>(
              value: _difficulty,
              decoration: const InputDecoration(labelText: 'Difficulty Level', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'any', child: Text('Any Difficulty')),
                DropdownMenuItem(value: 'easy', child: Text('Easy')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'hard', child: Text('Hard')),
              ],
              onChanged: (val) => setState(() => _difficulty = val!),
            ),
            const SizedBox(height: 16),

            // Dropdown for type
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Question Type', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'any', child: Text('Any Type')),
                DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice')),
                DropdownMenuItem(value: 'boolean', child: Text('True / False')),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005F56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        amount: _questionCount.toInt(),
                        categoryId: widget.category.id,
                        difficulty: _difficulty,
                        type: _type,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
                child: const Text('START', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}