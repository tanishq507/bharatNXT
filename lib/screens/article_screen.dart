import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../providers/article_provider.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;
  
  const ArticleScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
        actions: [
          Consumer<ArticleProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Icon(
                  article.isFavorite 
                      ? Icons.favorite 
                      : Icons.favorite_outline,
                  color: article.isFavorite 
                      ? Colors.red 
                      : null,
                ),
                onPressed: () {
                  provider.toggleFavorite(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        article.isFavorite 
                            ? 'Removed from favorites' 
                            : 'Added to favorites',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'article-title-${article.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                article.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'User ID: ${article.userId}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.numbers, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Article ID: ${article.id}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}