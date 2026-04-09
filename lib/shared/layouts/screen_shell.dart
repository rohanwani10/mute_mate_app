import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bottom_nav.dart';
import 'app_bar.dart';

class MuteMateScreenShell extends ConsumerWidget {
  final Widget child;
  final String? title;
  final bool showProfile;
  final bool showNotifications;
  final List<Widget>? actions;
  final bool showBottomNav;

  final Widget? leading;

  const MuteMateScreenShell({
    super.key,
    required this.child,
    this.title,
    this.showProfile = false,
    this.showNotifications = false,
    this.actions,
    this.showBottomNav = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      appBar: MuteMateAppBar(
        title: title,
        showProfile: showProfile,
        showNotifications: showNotifications,
        actions: actions,
        leading: leading,
      ),
      body: child,
      bottomNavigationBar: showBottomNav ? const MuteMateBottomNav() : null,
    );
  }
}
