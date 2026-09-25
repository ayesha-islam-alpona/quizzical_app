import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'config_screen.dart';

class CategoryStyle {
  final Color bg;
  final Color iconColor;
  final IconData icon;

  const CategoryStyle({required this.bg, required this.iconColor, required this.icon});
}

CategoryStyle getCategoryStyle(int categoryId) {
  final Map<int, CategoryStyle> styles = {
    9: const CategoryStyle(bg: Color(0xFFCBE3FB), iconColor: Color(0xFF384D63), icon: Icons.interests_rounded),
    10: const CategoryStyle(bg: Color(0xFFCBE5C8), iconColor: Color(0xFF3A543A), icon: Icons.menu_book_rounded),
    11: const CategoryStyle(bg: Color(0xFFFFF6B8), iconColor: Color(0xFF575232), icon: Icons.movie_rounded),
    12: const CategoryStyle(bg: Color(0xFFE5C5ED), iconColor: Color(0xFF56385A), icon: Icons.music_note_rounded),
    13: const CategoryStyle(bg: Color(0xFFFBC0D0), iconColor: Color(0xFF5A3343), icon: Icons.music_note_rounded),
    14: const CategoryStyle(bg: Color(0xFFB3EFF4), iconColor: Color(0xFF2E5155), icon: Icons.tv_rounded),
    15: const CategoryStyle(bg: Color(0xFFFFDFB8), iconColor: Color(0xFF5C4731), icon: Icons.sports_esports_rounded),
    16: const CategoryStyle(bg: Color(0xFFB2E5DC), iconColor: Color(0xFF32524A), icon: Icons.casino_rounded),
    17: const CategoryStyle(bg: Color(0xFFD1F2D9), iconColor: Color(0xFF33573A), icon: Icons.science_rounded),
    18: const CategoryStyle(bg: Color(0xFFD4E3FC), iconColor: Color(0xFF3B4F73), icon: Icons.computer_rounded),
    19: const CategoryStyle(bg: Color(0xFFFFF1B8), iconColor: Color(0xFF594F2B), icon: Icons.calculate_rounded),
    20: const CategoryStyle(bg: Color(0xFFE2D4F8), iconColor: Color(0xFF4C366B), icon: Icons.auto_awesome_rounded),
    21: const CategoryStyle(bg: Color(0xFFE3F2C1), iconColor: Color(0xFF455728), icon: Icons.sports_soccer_rounded),
    22: const CategoryStyle(bg: Color(0xFFC5EAF8), iconColor: Color(0xFF2C5061), icon: Icons.public_rounded),
    23: const CategoryStyle(bg: Color(0xFFFBE4C1), iconColor: Color(0xFF5C482A), icon: Icons.history_edu_rounded),
    24: const CategoryStyle(bg: Color(0xFFF8C8C8), iconColor: Color(0xFF5B3030), icon: Icons.gavel_rounded),
    25: const CategoryStyle(bg: Color(0xFFE9C5ED), iconColor: Color(0xFF58315C), icon: Icons.palette_rounded),
    26: const CategoryStyle(bg: Color(0xFFFFF0B8), iconColor: Color(0xFF5C4F28), icon: Icons.star_rounded),
    27: const CategoryStyle(bg: Color(0xFFFFE2C1), iconColor: Color(0xFF5C4328), icon: Icons.pets_rounded),
    28: const CategoryStyle(bg: Color(0xFFC1F0E3), iconColor: Color(0xFF2B5C50), icon: Icons.directions_car_rounded),
    29: const CategoryStyle(bg: Color(0xFFF8C5DB), iconColor: Color(0xFF5C2B42), icon: Icons.menu_book_sharp),
    30: const CategoryStyle(bg: Color(0xFFCBE3FB), iconColor: Color(0xFF384D63), icon: Icons.devices_rounded),
    31: const CategoryStyle(bg: Color(0xFFF8C5C5), iconColor: Color(0xFF5C2B2B), icon: Icons.animation_rounded),
    32: const CategoryStyle(bg: Color(0xFFD4F8C5), iconColor: Color(0xFF3B5C2B), icon: Icons.smart_toy_rounded),
  };

  return styles[categoryId] ??
      const CategoryStyle(
        bg: Color(0xFFE0E0E0),
        iconColor: Color(0xFF424242),
        icon: Icons.category_rounded,
      );
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Quizzical',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C343E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'choose a category to focus on:',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<QuizProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoadingCategories) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.categoryError != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 12),
                            const Text('Failed to load categories'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => provider.fetchCategories(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.88,
                      ),
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        final style = getCategoryStyle(category.id);
                        String displayName = category.name
                            .replaceAll('Entertainment: ', '')
                            .replaceAll('Science: ', '');

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConfigScreen(category: category),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: style.bg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(style.icon, size: 56, color: style.iconColor),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(
                                    displayName,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF1E1E1E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}