import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../models/article.dart';
import '../screens/article_screen.dart';
import 'article_list_item.dart';

class ArticleList extends StatelessWidget {
  final List<Article> articles;
  
  const ArticleList({
    super.key,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const Center(
        child: Text('No articles found'),
      );
    }
    
    return AnimationLimiter(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 350),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: ArticleListItem(
                  article: articles[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => 
                          ArticleScreen(article: articles[index]),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var curve = Curves.easeInOutCubic;
                          var curveTween = CurveTween(curve: curve);
                          
                          return FadeTransition(
                            opacity: animation.drive(curveTween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}