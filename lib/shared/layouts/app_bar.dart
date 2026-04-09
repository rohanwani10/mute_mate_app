import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import '../providers/nav_provider.dart';

class MuteMateAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showProfile;
  final bool showNotifications;
  final List<Widget>? actions;
  final Widget? leading;

  const MuteMateAppBar({
    super.key,
    this.title,
    this.showProfile = false,
    this.showNotifications = false,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: leading ?? (showProfile ? _ProfileAvatar() : null),
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          : Text(
              'MuteMate',
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

class _ProfileAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            )
          ],
        ),
        child: const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAMocZ4tIeVHX_69_miMWxPPnNapVjjnQIYmGwED9YtqwVo4stUBZgUODm9Kghg8Y_evVnaAFdI13HzCVCt7w9nnbd9x9gF941EoVzSssGD5bhapliOVXMCRyACddE1ZdQEkt5LzQ8jm4bdLu6w1vjrie75WcMt6Lsprr-JdhlUaNxwI4TLs4f4FVYQ7u46q-sIqGJfHNoZExs-7muau_okTrlg1YfE9Q-Mp5A5T164-Yeq8opVGFJc7_v3e9UP1_bHhIf3u69mEkhK',
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
          icon: const Icon(Icons.notifications_none, color: AppColors.onSurfaceVariant),
          onPressed: () => ref.read(isNotificationsVisibleProvider.notifier).state = true,
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
