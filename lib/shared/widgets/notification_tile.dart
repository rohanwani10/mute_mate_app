import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class MuteMateNotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final bool isUnread;

  const MuteMateNotificationTile({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Slightly tighter padding for a cleaner look
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerlowest,
        borderRadius: BorderRadius.circular(20), // Match quick action tile radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              letterSpacing: -0.2,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          time,
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant.withOpacity(0.8),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Unread Indicator Dot
          if (isUnread)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
