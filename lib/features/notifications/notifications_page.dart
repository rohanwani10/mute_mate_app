import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/notification_tile.dart';
import '../../shared/widgets/action_card.dart';
import '../../shared/widgets/pill_slider.dart';
import '../../shared/providers/notification_provider.dart';
import '../../core/app_theme.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(notificationFilterProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Centered Filter Slider
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: MuteMateSlidingPill(
                labels: const ['All', 'Learning', 'Account'],
                selectedIndex: NotificationFilter.values.indexOf(activeFilter),
                onSegmentChosen: (index) {
                  ref.read(notificationFilterProvider.notifier).state =
                      NotificationFilter.values[index];
                },
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Notification Content
          _buildNotificationList(activeFilter),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildNotificationList(NotificationFilter activeFilter) {
    final List<Widget> items = [];

    if (activeFilter == NotificationFilter.all ||
        activeFilter == NotificationFilter.learning) {
      items.addAll([
        MuteMateActionCard(
          title: 'Streak at risk!',
          subtitle:
              "You're just 1 lesson away from keeping your 12-day streak alive. Don't let it slip away!",
          icon: Icons.local_fire_department_outlined,
          backgroundColor: AppColors.secondary,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFD761A), // Lighter secondary
              AppColors.secondary, // Deep secondary
            ],
          ),
          backgroundIconColor: Colors.black,
          buttonText: 'Practice Now',
          badgeText: 'PRIORITY',
          onActionPressed: () {},
        ),
        const SizedBox(height: 16),
        const MuteMateNotificationTile(
          title: 'New Unit Available',
          body:
              'Unit 4: Advanced ASL Sentence Structures is now unlocked for your profile.',
          time: '2h ago',
          icon: Icons.auto_stories,
          iconBackgroundColor: AppColors.iconBg,
          iconColor: AppColors.primaryFixed,
          isUnread: true,
        ),
        const SizedBox(height: 16),
        const MuteMateNotificationTile(
          title: 'Badge Earned!',
          body:
              "Congratulations! You've earned the 'Consistent Communicator' silver badge.",
          time: '5h ago',
          icon: Icons.military_tech,
          iconBackgroundColor: AppColors.iconBg,
          iconColor: AppColors.tertiary,
        ),
        const SizedBox(height: 16),
      ]);
    }

    if (activeFilter == NotificationFilter.all ||
        activeFilter == NotificationFilter.account) {
      items.addAll([
        const MuteMateNotificationTile(
          title: 'Password Updated',
          body:
              'Your account password was successfully changed from a new device in San Francisco.',
          time: 'Yesterday',
          icon: Icons.lock_outline_rounded,
          iconBackgroundColor: AppColors.surfaceContainerHigh,
          iconColor: AppColors.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        const MuteMateNotificationTile(
          title: 'System Maintenance',
          body:
              "We'll be performing scheduled maintenance on Friday at 2:00 AM EST.",
          time: '2 days ago',
          icon: Icons.notifications_outlined,
          iconBackgroundColor: AppColors.primary,
          iconColor: AppColors.onPrimary,
        ),
        const SizedBox(height: 16),
      ]);
    }

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.done_all, color: Colors.grey, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'All caught up!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'No more notifications for now.',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: items);
  }
}
