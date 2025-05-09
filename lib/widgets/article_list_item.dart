import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../providers/article_provider.dart';

class ArticleListItem extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  
  const ArticleListItem({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
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
              backgroundColor: article.isFavorite 
                  ? Colors.red.shade700 
                  : Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: article.isFavorite 
                  ? Colors.white 
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              icon: article.isFavorite ? Icons.favorite : Icons.favorite_outline,
              label: article.isFavorite ? 'Unfavorite' : 'Favorite',
            ),
          ],
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'article-title-${article.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (article.isFavorite)
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${article.body.substring(0, article.body.length > 100 ? 100 : article.body.length)}${article.body.length > 100 ? '...' : ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User ID: ${article.userId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        'Article ID: ${article.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}