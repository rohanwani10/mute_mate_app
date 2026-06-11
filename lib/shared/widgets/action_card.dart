import 'package:flutter/material.dart';

class MuteMateActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Gradient? gradient;
  final Color? accentColor;
  final Color? backgroundIconColor;
  final String buttonText;
  final VoidCallback onActionPressed;
  final String? badgeText;

  const MuteMateActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    this.gradient,
    this.accentColor,
    this.backgroundIconColor,
    required this.buttonText,
    required this.onActionPressed,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Icon
            Positioned(
              right: -40,
              bottom: -40,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  icon,
                  size: 240,
                  color: backgroundIconColor ?? Colors.black,
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              accentColor ??
                              Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Icon(icon, color: Colors.white, size: 32),
                      ),
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),

                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    autofocus: true,
                    onPressed: onActionPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: backgroundColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          buttonText,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
