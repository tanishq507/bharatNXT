import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import '../providers/article_provider.dart';
import '../screens/article_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/article_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  final List<Widget> _pages = [
    const ArticleListScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    'Articles',
    'Favorites',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [Colors.grey.shade900, Colors.black]
                    : [Colors.white, Colors.grey.shade100],
              ),
            ),
          ),
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _titles[_selectedIndex],
              key: ValueKey<String>(_titles[_selectedIndex]),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          actions: [
            if (_selectedIndex == 0 || _selectedIndex == 1)
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey.shade800.withOpacity(0.5)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search articles',
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: AppSearchBar(),
                    );
                  },
                ),
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: NavigationBar(
                height: 70,
                elevation: 0,
                backgroundColor: isDarkMode
                    ? Colors.grey.shade900.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                animationDuration: const Duration(milliseconds: 500),
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _animationController.reset();
                    _animationController.forward();
                  });
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.article_outlined),
                    selectedIcon: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [
                            Colors.purple.shade300,
                            Colors.blue.shade500
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Icon(Icons.article, color: Colors.white),
                    ),
                    label: 'Articles',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.favorite_outline),
                    selectedIcon: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.red.shade300, Colors.orange.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Icon(Icons.favorite, color: Colors.white),
                    ),
                    label: 'Favorites',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.teal.shade300, Colors.green.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Icon(Icons.settings, color: Colors.white),
                    ),
                    label: 'Settings',
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

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ArticleProvider>(
      builder: (context, provider, child) {
        if (provider.status == ArticleStatus.initial ||
            provider.status == ArticleStatus.loading &&
                provider.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
                    ),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Loading articles...',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.hasError) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Oops! Something went wrong',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => provider.fetchArticles(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      backgroundColor: isDarkMode
                          ? Colors.blue.shade700
                          : Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.fetchArticles,
          color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
          backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
          strokeWidth: 3,
          displacement: 40,
          child: ArticleList(articles: provider.filteredArticles),
        );
      },
    );
  }
}
