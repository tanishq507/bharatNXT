import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../providers/article_provider.dart';
import '../widgets/article_list.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ArticleProvider>(
      builder: (context, provider, child) {
        if (provider.favorites.isEmpty) {
          return EmptyFavoritesView();
        }

        return ArticleList(articles: provider.favorites);
      },
    );
  }
}

class EmptyFavoritesView extends StatefulWidget {
  const EmptyFavoritesView({super.key});

  @override
  State<EmptyFavoritesView> createState() => _EmptyFavoritesViewState();
}

class _EmptyFavoritesViewState extends State<EmptyFavoritesView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _heartbeatAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [Colors.grey.shade900, Colors.black]
              : [Colors.white, Colors.grey.shade100],
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: size.height - 160, // Adjust for app bar and bottom nav
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated heart icon
              AnimatedBuilder(
                animation: _heartbeatAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _heartbeatAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey.shade800.withOpacity(0.5)
                            : Colors.grey.shade200.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.red.shade300,
                                Colors.pink.shade400,
                                Colors.purple.shade300,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Floating cards background effect
              Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    Positioned(
                      top: -10.0 + (i * 5),
                      left: 20.0 - (i * 10),
                      child: Transform.rotate(
                        angle: -0.1 + (i * 0.05),
                        child: Opacity(
                          opacity: 0.2 + (i * 0.1),
                          child: Container(
                            width: 60,
                            height: 80,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Main text content
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          'No favorites yet',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Articles you love will appear here.\nTap the heart icon on any article to add it to your favorites.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade700,
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Enhanced button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.blue.shade900.withOpacity(0.3)
                          : Colors.blue.shade300.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.article_rounded),
                  label: const Text('Discover Articles'),
                  onPressed: () {
                    // Navigate to Articles tab (index 0)
                    // This is a more reliable way to navigate than using DefaultTabController
                    // since the parent is using a custom navigation approach
                    final scaffoldState = Scaffold.of(context);
                    if (scaffoldState is ScaffoldState) {
                      // Try to find the parent HomePage state to change the index
                      final homePageState =
                          context.findAncestorStateOfType<State>();
                      if (homePageState != null) {
                        // Use reflection to access the _selectedIndex field
                        // This is a workaround and might not work in all cases
                        try {
                          final field = homePageState.runtimeType.toString();
                          if (field.contains('_HomePageState')) {
                            // Navigate to the first tab using the parent's navigation method
                            // This is a simplified approach - in a real app, you'd use a proper navigation method
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed('/');
                          }
                        } catch (e) {
                          // Fallback to just popping if we can't navigate directly
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    backgroundColor: isDarkMode
                        ? Colors.blue.shade700
                        : Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: const Size(200, 56),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Decorative elements
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
