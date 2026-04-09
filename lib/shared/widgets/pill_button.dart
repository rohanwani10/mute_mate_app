import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class MuteMatePillButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const MuteMatePillButton({
    super.key,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(99),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
