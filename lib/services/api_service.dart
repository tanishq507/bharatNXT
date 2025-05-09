import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}