import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../models/learn_models.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({required this.category, required this.onTap, super.key});

  IconData _getIcon(IconType type) {
    switch (type) {
      case IconType.autoAwesome:
        return Icons.auto_awesome_outlined;
      case IconType.routine:
        return Icons.schedule_outlined;
      case IconType.mood:
        return Icons.mood_outlined;
      case IconType.work:
        return Icons.work_outline;
      case IconType.medicalServices:
        return Icons.medical_services_outlined;
      case IconType.flight:
        return Icons.flight_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerlowest,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(50),
            hoverColor: AppColors.primaryFixed.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      _getIcon(category.icon),
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
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
