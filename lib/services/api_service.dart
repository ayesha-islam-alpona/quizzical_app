import 'dart:convert' as json;
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com';

  static Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/api_category.php'));
    if (response.statusCode == 200) {
      final data = json.jsonDecode(response.body);
      List categoriesJson = data['trivia_categories'];
      return categoriesJson.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  static Future<List<QuestionModel>> fetchQuestions({
    required int amount,
    required int categoryId,
    required String difficulty,
    required String type,
  }) async {
    String url = '$_baseUrl/api.php?amount=$amount&category=$categoryId';
    if (difficulty != 'any') url += '&difficulty=$difficulty';
    if (type != 'any') url += '&type=$type';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.jsonDecode(response.body);
      List questionsJson = data['results'];
      return questionsJson.map((e) => QuestionModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch questions');
    }
  }
}