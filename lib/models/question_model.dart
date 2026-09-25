class QuestionModel {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> options;

  QuestionModel({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // 1. Combine correct and incorrect answers into one list
    List<String> allOptions = List<String>.from(json['incorrect_answers']);
    allOptions.add(json['correct_answer']);

    // 2. Shuffle so the correct answer isn't always last
    allOptions.shuffle();

    return QuestionModel(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: _decodeHtml(json['question']),
      correctAnswer: _decodeHtml(json['correct_answer']),
      incorrectAnswers: (json['incorrect_answers'] as List)
          .map((e) => _decodeHtml(e.toString()))
          .toList(),
      options: allOptions.map((e) => _decodeHtml(e)).toList(),
    );
  }

  // OpenTDB returns encoded HTML characters (e.g. &quot;, &#039;)
  static String _decodeHtml(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&deg;', '°');
  }
}