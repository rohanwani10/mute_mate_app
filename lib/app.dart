import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'shared/layouts/screen_shell.dart';
import 'shared/providers/nav_provider.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/notifications/notifications_page.dart';

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
            title: null, // Title is handled by tabs or shell defaults
            showProfile: activeTab == MuteMateTab.home,
            showNotifications: activeTab == MuteMateTab.home,
            showBottomNav: true,
            child: _buildPage(activeTab),
          ),

          // Notification Overlay (Symmetric Entry/Exit)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            left: isNotificationsVisible ? 0 : MediaQuery.of(context).size.width,
            right: isNotificationsVisible ? 0 : -MediaQuery.of(context).size.width,
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
                  onPressed: () => ref.read(isNotificationsVisibleProvider.notifier).state = false,
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
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
      case MuteMateTab.translate:
        return const PlaceholderPage('Translate Page');
      case MuteMateTab.learn:
        return const PlaceholderPage('Learn Page');
      case MuteMateTab.profile:
        return const PlaceholderPage('Profile Page');
      default:
        return const DashboardPage();
    }
  }
}
