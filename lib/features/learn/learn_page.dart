import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import 'providers/learn_provider.dart';
import 'widgets/category_card.dart';
import 'widgets/lesson_card.dart';
import 'widgets/recent_search_chip.dart';

class LearnPage extends ConsumerWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final trendingLessons = ref.watch(trendingLessonsProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sticky Search Section
          _StickySearchBar(),
          const SizedBox(height: 24),

          // Recent Searches Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: .6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: recentSearches
                      .map(
                        (search) =>
                            RecentSearchChip(label: search, onTap: () {}),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Suggested Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggested Categories',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      category: categories[index],
                      onTap: () {},
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Trending Lessons Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Lessons',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trendingLessons.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return LessonCard(
                      lesson: trendingLessons[index],
                      onTap: () {},
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32), // Padding for bottom nav
        ],
      ),
    );
  }
}

class _StickySearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search lessons or signs...',
              hintStyle: TextStyle(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
                color: AppColors.primary,
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.mic,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
