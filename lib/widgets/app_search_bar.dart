import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../providers/article_provider.dart';
import '../screens/article_screen.dart';

class AppSearchBar extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search articles...';
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context, listen: false);
    provider.searchArticles(query);
    
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context, listen: false);
    
    if (query.isNotEmpty) {
      provider.searchArticles(query);
    }
    
    return _buildSearchResults(context);
  }
  
  Widget _buildSearchResults(BuildContext context) {
    return Consumer<ArticleProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final articles = query.isEmpty ? provider.articles : provider.filteredArticles;
        
        if (articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try different keywords',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return ListTile(
              title: Text(
                article.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                article.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Text(article.id.toString()),
              ),
              trailing: Icon(
                article.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: article.isFavorite ? Colors.red : null,
              ),
              onTap: () {
                close(context, article.id.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleScreen(article: article),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.brightness == Brightness.dark 
              ? Colors.white70 
              : Colors.black54,
        ),
        border: InputBorder.none,
      ),
    );
  }
}