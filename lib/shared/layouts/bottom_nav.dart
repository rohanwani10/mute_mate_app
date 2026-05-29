import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mute_mate_app/shared/widgets/quick_actions_bottom_sheet.dart';
import '../providers/nav_provider.dart';
import '../../core/app_theme.dart';

class MuteMateBottomNav extends ConsumerWidget {
  const MuteMateBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.teal.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 24.0,
            left: 16,
            right: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _NavButton(
                  icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => ref.read(navIndexProvider.notifier).state = 0,
                ),
              ),
              Expanded(
                child: _NavButton(
                  icon: currentIndex == 1
                      ? Icons.translate
                      : Icons.translate_outlined,
                  label: 'Translate',
                  isActive: currentIndex == 1,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      useSafeArea: true,
                      builder: (context) => const QuickActionsBottomSheet(),
                    );
                  },
                ),
              ),
              Expanded(
                child: _NavButton(
                  icon: currentIndex == 2
                      ? Icons.auto_stories
                      : Icons.auto_stories_outlined,
                  label: 'Learn',
                  isActive: currentIndex == 2,
                  onTap: () => ref.read(navIndexProvider.notifier).state = 2,
                ),
              ),
              Expanded(
                child: _NavButton(
                  icon: currentIndex == 3 ? Icons.person : Icons.person_outline,
                  label: 'Profile',
                  isActive: currentIndex == 3,
                  onTap: () => ref.read(navIndexProvider.notifier).state = 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.teal.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
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
