import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import '../providers/nav_provider.dart';
import '../../features/profile/providers/profile_provider.dart';

class MuteMateAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final String? title;
  final bool showProfile;
  final bool showNotifications;
  final List<Widget>? actions;
  final Widget? leading;

  const MuteMateAppBar({
    super.key,
    this.titleWidget,
    this.title,
    this.showProfile = false,
    this.showNotifications = false,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.background.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: leading ?? (showProfile ? _ProfileAvatar() : null),
      title:
          titleWidget ??
          Text(
            title ?? 'MuteMate',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF00685F),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
      actions: [
        if (showNotifications) _NotificationIcon(),
        if (actions != null) ...actions!,
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfileAvatar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = ref.watch(profileProvider.select((p) => p.avatarUrl));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          ref.read(navIndexProvider.notifier).state =
              3; // Switch to settings tab
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
      ),
    );
  }
}

class _NotificationIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.onSurfaceVariant,
          ),
          onPressed: () =>
              ref.read(isNotificationsVisibleProvider.notifier).state = true,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
