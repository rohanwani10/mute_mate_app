import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mute_mate_app/features/learn/learn_page.dart';
import 'core/app_theme.dart';
import 'shared/layouts/screen_shell.dart';
import 'shared/providers/nav_provider.dart';
import 'features/dashboard/dashboard_page.dart';
import 'package:mute_mate_app/features/notifications/notifications_page.dart';
import 'package:mute_mate_app/features/profile/profile_page.dart';
import 'package:mute_mate_app/features/settings/providers/settings_provider.dart';

// Temporary placeholder pages
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text(title));
}

class MuteMateApp extends ConsumerWidget {
  const MuteMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MuteMate',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AppHome(),
    );
  }
}

class AppHome extends ConsumerWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);
    final isNotificationsVisible = ref.watch(isNotificationsVisibleProvider);

    return PopScope(
      canPop: !isNotificationsVisible,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(isNotificationsVisibleProvider.notifier).state = false;
      },
      child: Stack(
        children: [
          // Main Application Shell
          MuteMateScreenShell(
            title: activeTab == MuteMateTab.profile
                ? (ref.watch(isSettingsSearchActiveProvider)
                      ? null
                      : 'Settings')
                : 'MuteMate',
            titleWidget:
                activeTab == MuteMateTab.profile &&
                    ref.watch(isSettingsSearchActiveProvider)
                ? const _AppBarSearchField()
                : null,
            showProfile: activeTab != MuteMateTab.profile,
            showNotifications: activeTab != MuteMateTab.profile,
            showBottomNav: true,
            leading: activeTab == MuteMateTab.profile
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (ref.read(isSettingsSearchActiveProvider)) {
                        ref
                                .read(isSettingsSearchActiveProvider.notifier)
                                .state =
                            false;
                        ref.read(settingsSearchQueryProvider.notifier).state =
                            '';
                      } else {
                        ref.read(navIndexProvider.notifier).state = 0;
                      }
                    },
                  )
                : null,
            actions: activeTab == MuteMateTab.profile
                ? [
                    if (ref.watch(isSettingsSearchActiveProvider))
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          ref
                                  .read(isSettingsSearchActiveProvider.notifier)
                                  .state =
                              false;
                          ref.read(settingsSearchQueryProvider.notifier).state =
                              '';
                        },
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          ref
                                  .read(isSettingsSearchActiveProvider.notifier)
                                  .state =
                              true;
                        },
                      ),
                  ]
                : null,
            child: _buildPage(activeTab),
          ),

          // Notification Overlay (Symmetric Entry/Exit)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            left: isNotificationsVisible
                ? 0
                : MediaQuery.of(context).size.width,
            right: isNotificationsVisible
                ? 0
                : -MediaQuery.of(context).size.width,
            top: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: MuteMateScreenShell(
                title: 'Notifications',
                showProfile: false,
                showNotifications: false,
                showBottomNav: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () =>
                      ref.read(isNotificationsVisibleProvider.notifier).state =
                          false,
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Read All.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                child: const NotificationsPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(MuteMateTab tab) {
    switch (tab) {
      case MuteMateTab.home:
        return const DashboardPage();
      case MuteMateTab.learn:
        return const LearnPage();
      case MuteMateTab.profile:
        return const ProfilePage();
      default:
        return const DashboardPage();
    }
  }
}

class _AppBarSearchField extends ConsumerStatefulWidget {
  const _AppBarSearchField();

  @override
  ConsumerState<_AppBarSearchField> createState() => _AppBarSearchFieldState();
}

class _AppBarSearchFieldState extends ConsumerState<_AppBarSearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(settingsSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(settingsSearchQueryProvider, (prev, next) {
      if (_controller.text != next) {
        _controller.text = next;
      }
    });

    return TextField(
      controller: _controller,
      autofocus: true,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: 'Search settings...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          fontWeight: FontWeight.normal,
        ),
      ),
      onChanged: (val) {
        ref.read(settingsSearchQueryProvider.notifier).state = val;
      },
    );
  }
}
