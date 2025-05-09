import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';

class FavoritesService {
  static const String key = 'favorite_articles';
  
  Future<List<Article>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(key);
    
    if (favoritesJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      return decoded.map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
  
  Future<void> saveFavorites(List<Article> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final String favoritesJson = jsonEncode(
      favorites.map((article) => article.toJson()).toList(),
    );
    
    await prefs.setString(key, favoritesJson);
  }
  
  Future<void> toggleFavorite(Article article) async {
    final favorites = await getFavorites();
    final index = favorites.indexWhere((a) => a.id == article.id);
    
    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.add(article.copyWith(isFavorite: true));
    }
    
    await saveFavorites(favorites);
  }
  
  Future<bool> isFavorite(int id) async {
    final favorites = await getFavorites();
    return favorites.any((article) => article.id == id);
  }
}