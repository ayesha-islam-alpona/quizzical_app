import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class QuizProvider extends ChangeNotifier {
  // Session Category Cache
  List<CategoryModel> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoryError;

  List<CategoryModel> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoryError => _categoryError;

  // Quiz Configuration Defaults
  int _amount = 10;
  String _difficulty = 'any';
  String _type = 'multiple';

  int get amount => _amount;
  String get difficulty => _difficulty;
  String get type => _type;

  // Active Quiz State
  List<QuestionModel> _questions = [];
  bool _isLoadingQuestions = false;
  String? _questionError;
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _isAnswered = false;

  // Timer & Statistics
  static const int questionDuration = 20;
  int _timeLeft = questionDuration;
  Timer? _timer;
  DateTime? _quizStartTime;
  int _totalTimeInSeconds = 0;

  List<QuestionModel> get questions => _questions;
  bool get isLoadingQuestions => _isLoadingQuestions;
  String? get questionError => _questionError;
  int get currentIndex => _currentIndex;
  int get score => _score;
  String? get selectedOption => _selectedOption;
  bool get isAnswered => _isAnswered;
  int get timeLeft => _timeLeft;
  int get totalTimeInSeconds => _totalTimeInSeconds;

  QuizProvider() {
    loadSavedConfig();
  }

  // --- Category Fetch & Session Caching ---
  Future<void> fetchCategories() async {
    if (_categories.isNotEmpty) return; // Cache hit

    _isLoadingCategories = true;
    _categoryError = null;
    notifyListeners();

    try {
      _categories = await ApiService.fetchCategories();
    } catch (e) {
      _categoryError = e.toString();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // --- SharedPreferences Persistence ---
  Future<void> loadSavedConfig() async {
    final prefs = await SharedPreferences.getInstance();
    _amount = prefs.getInt('pref_amount') ?? 10;
    _difficulty = prefs.getString('pref_difficulty') ?? 'any';
    _type = prefs.getString('pref_type') ?? 'multiple';
    notifyListeners();
  }

  Future<void> updateConfig({int? amount, String? difficulty, String? type}) async {
    if (amount != null) _amount = amount;
    if (difficulty != null) _difficulty = difficulty;
    if (type != null) _type = type;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pref_amount', _amount);
    await prefs.setString('pref_difficulty', _difficulty);
    await prefs.setString('pref_type', _type);
  }

  // --- Quiz Lifecycle & Questions ---
  Future<void> startQuiz(int categoryId) async {
    _isLoadingQuestions = true;
    _questionError = null;
    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _selectedOption = null;
    _isAnswered = false;
    _totalTimeInSeconds = 0;
    notifyListeners();

    try {
      _questions = await ApiService.fetchQuestions(
        amount: _amount,
        categoryId: categoryId,
        difficulty: _difficulty,
        type: _type,
      );
      _quizStartTime = DateTime.now();
      _startTimer();
    } catch (e) {
      _questionError = e.toString();
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = questionDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _isAnswered = true;
    notifyListeners();
  }

  void selectOption(String option) {
    if (_isAnswered) return;
    _timer?.cancel();
    _selectedOption = option;
    _isAnswered = true;

    if (option == _questions[_currentIndex].correctAnswer) {
      _score++;
    }
    notifyListeners();
  }

  bool nextQuestion() {
    _timer?.cancel();
    if (_currentIndex + 1 < _questions.length) {
      _currentIndex++;
      _selectedOption = null;
      _isAnswered = false;
      _startTimer();
      return false; // Quiz incomplete
    } else {
      if (_quizStartTime != null) {
        _totalTimeInSeconds = DateTime.now().difference(_quizStartTime!).inSeconds;
      }
      return true; // Quiz completed
    }
  }

  void resetQuiz() {
    _timer?.cancel();
    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _selectedOption = null;
    _isAnswered = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}