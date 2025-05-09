import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

enum ArticleStatus { initial, loading, loaded, error }

class ArticleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FavoritesService _favoritesService = FavoritesService();
  
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  List<Article> _favorites = [];
  String _searchQuery = '';
  String _errorMessage = '';
  ArticleStatus _status = ArticleStatus.initial;
  
  List<Article> get articles => _articles;
  List<Article> get filteredArticles => _searchQuery.isEmpty 
      ? _articles 
      : _filteredArticles;
  List<Article> get favorites => _favorites;
  String get errorMessage => _errorMessage;
  ArticleStatus get status => _status;
  bool get isLoading => _status == ArticleStatus.loading;
  bool get hasError => _status == ArticleStatus.error;
  
  ArticleProvider() {
    fetchArticles();
    loadFavorites();
  }
  
  Future<void> fetchArticles() async {
    if (_status == ArticleStatus.loading) return;
    
    _status = ArticleStatus.loading;
    notifyListeners();
    
    try {
      final articles = await _apiService.fetchArticles();
      
      // Update with favorite status
      for (var i = 0; i < articles.length; i++) {
        final article = articles[i];
        final isFavorite = await _favoritesService.isFavorite(article.id);
        if (isFavorite) {
          articles[i] = article.copyWith(isFavorite: true);
        }
      }
      
      _articles = articles;
      _applySearch();
      _status = ArticleStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ArticleStatus.error;
    }
    
    notifyListeners();
  }
  
  Future<void> loadFavorites() async {
    _favorites = await _favoritesService.getFavorites();
    notifyListeners();
  }
  
  Future<void> toggleFavorite(Article article) async {
    // Toggle in articles list
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index >= 0) {
      final isFavorite = !_articles[index].isFavorite;
      _articles[index] = _articles[index].copyWith(isFavorite: isFavorite);
    }
    
    // Toggle in filtered list if it exists there
    final filteredIndex = _filteredArticles.indexWhere((a) => a.id == article.id);
    if (filteredIndex >= 0) {
      final isFavorite = !_filteredArticles[filteredIndex].isFavorite;
      _filteredArticles[filteredIndex] = _filteredArticles[filteredIndex].copyWith(isFavorite: isFavorite);
    }
    
    // Save to storage
    await _favoritesService.toggleFavorite(article);
    
    // Reload favorites
    await loadFavorites();
  }
  
  void searchArticles(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }
  
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredArticles = _articles;
      return;
    }
    
    final queryLower = _searchQuery.toLowerCase();
    _filteredArticles = _articles.where((article) {
      return article.title.toLowerCase().contains(queryLower) || 
             article.body.toLowerCase().contains(queryLower);
    }).toList();
  }
  
  void clearSearch() {
    _searchQuery = '';
    _filteredArticles = _articles;
    notifyListeners();
  }
}