import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import '../settings/providers/settings_provider.dart';
import 'providers/profile_provider.dart';
import 'widgets/edit_profile_dialog.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final searchQuery = ref
        .watch(settingsSearchQueryProvider)
        .trim()
        .toLowerCase();

    bool matches(String title) {
      if (searchQuery.isEmpty) return true;
      return title.toLowerCase().contains(searchQuery);
    }

    final accountTiles = [
      _SettingsTile(
        icon: Icons.person_outline,
        title: 'Edit Profile',
        onTap: () => _showEditProfile(context),
      ),
      _SettingsTile(
        icon: Icons.lock_reset,
        title: 'Change Password',
        onTap: () => _showMockDialog(
          context,
          'Change Password',
          'A password reset link has been sent to your email: ${profile.email}',
        ),
      ),
      _SettingsTile(
        icon: Icons.language,
        title: 'Language/Region',
        trailing: Text(
          settings.language,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        onTap: () => _showLanguageSelector(context, ref),
      ),
    ].where((tile) => matches(tile.title)).toList();

    final translationTiles = [
      _SettingsTile(
        iconColor: AppColors.primary,
        icon: Icons.sign_language,
        title: 'Default mode',
        trailing: Text(
          settings.defaultMode,
          style: TextStyle(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        onTap: () {
          final next = settings.defaultMode == 'Sign to Speech'
              ? 'Speech to Sign'
              : 'Sign to Speech';
          settingsNotifier.setDefaultMode(next);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Default mode set to $next'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
      _SettingsTile(
        onTap: () => settingsNotifier.toggleAutoSpeak(),
        icon: Icons.volume_up,
        iconColor: AppColors.primary,
        title: 'Auto-speak',
        trailing: _MuteMateSwitch(
          value: settings.autoSpeakEnabled,
          onChanged: (val) => settingsNotifier.toggleAutoSpeak(),
        ),
      ),
      _SettingsTile(
        iconColor: AppColors.primary,
        icon: Icons.tune,
        title: 'Sensitivity',
        trailing: Text(
          settings.sensitivity,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        onTap: () => _showSensitivitySelector(context, ref),
      ),
    ].where((tile) => matches(tile.title)).toList();

    final accessibilityTiles = [
      _SettingsTile(
        icon: Icons.contrast,
        title: 'High contrast',
        trailing: _MuteMateSwitch(
          value: settings.highContrastEnabled,
          onChanged: (val) => settingsNotifier.toggleHighContrast(),
        ),
        onTap: () => settingsNotifier.toggleHighContrast(),
      ),
      _SettingsTile(
        icon: Icons.text_fields,
        title: 'Text size',
        trailing: Text(
          settings.textSize,
          style: TextStyle(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        onTap: () => _showTextSizeSelector(context, ref),
      ),
      _SettingsTile(
        icon: Icons.record_voice_over,
        title: 'Voice guidance',
        onTap: () => _showMockDialog(
          context,
          'Voice Guidance',
          'Voice guidance is being set up. This will narrate the UI components for accessibility.',
        ),
      ),
    ].where((tile) => matches(tile.title)).toList();

    final notificationsTiles = [
      _SettingsTile(
        icon: Icons.event_repeat,
        title: 'Daily reminders',
        trailing: _MuteMateSwitch(
          value: settings.dailyRemindersEnabled,
          onChanged: (val) => settingsNotifier.toggleDailyReminders(),
        ),
        onTap: () => settingsNotifier.toggleDailyReminders(),
      ),
      _SettingsTile(
        icon: Icons.warning_amber_rounded,
        title: 'Streak warnings',
        trailing: _MuteMateSwitch(
          value: settings.streakWarningsEnabled,
          onChanged: (val) => settingsNotifier.toggleStreakWarnings(),
        ),
        onTap: () => settingsNotifier.toggleStreakWarnings(),
      ),
    ].where((tile) => matches(tile.title)).toList();

    final privacyTiles = [
      _SettingsTile(
        icon: Icons.policy_outlined,
        title: 'Privacy Policy',
        trailing: Icon(
          Icons.open_in_new,
          size: 16,
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Redirecting to Privacy Policy...')),
          );
        },
      ),
      _SettingsTile(
        icon: Icons.delete_forever,
        title: 'Delete account',
        titleColor: AppColors.error,
        iconColor: AppColors.error,
        onTap: () => _showDeleteAccountConfirm(context),
      ),
    ].where((tile) => matches(tile.title)).toList();

    final sessionTiles = [
      _SettingsTile(
        icon: Icons.logout,
        title: 'Logout',
        titleColor: AppColors.error,
        iconColor: AppColors.error,
        showChevron: false,
        onTap: () => _showLogoutConfirm(context),
      ),
    ].where((tile) => matches(tile.title)).toList();

    final hasResults =
        accountTiles.isNotEmpty ||
        translationTiles.isNotEmpty ||
        accessibilityTiles.isNotEmpty ||
        notificationsTiles.isNotEmpty ||
        privacyTiles.isNotEmpty ||
        sessionTiles.isNotEmpty;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchQuery.isEmpty) ...[
            // Profile Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerlowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: CachedNetworkImageProvider(profile.avatarUrl),
                        ),
                      ),
                      if (profile.isVerified)
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                profile.name,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                      fontSize: 20,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'VERIFIED',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          profile.email,
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _showEditProfile(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Toggles Row
            Row(
              children: [
                Expanded(
                  child: _QuickToggleCard(
                    icon: Icons.vibration,
                    label: 'Haptic',
                    value: settings.hapticEnabled,
                    onChanged: (val) => settingsNotifier.toggleHaptic(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickToggleCard(
                    icon: Icons.record_voice_over_outlined,
                    label: 'Voice',
                    value: settings.voiceEnabled,
                    onChanged: (val) => settingsNotifier.toggleVoice(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickToggleCard(
                    icon: Icons.motion_photos_off_outlined,
                    label: 'Motion',
                    value: settings.motionEnabled,
                    onChanged: (val) => settingsNotifier.toggleMotion(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          if (hasResults) ...[
            if (accountTiles.isNotEmpty) ...[
              _SettingsGroup(title: 'ACCOUNT', children: accountTiles),
              const SizedBox(height: 16),
            ],
            if (translationTiles.isNotEmpty) ...[
              _SettingsGroup(title: 'TRANSLATION', children: translationTiles),
              const SizedBox(height: 16),
            ],
            if (accessibilityTiles.isNotEmpty) ...[
              _SettingsGroup(
                title: 'ACCESSIBILITY',
                children: accessibilityTiles,
              ),
              const SizedBox(height: 16),
            ],
            if (notificationsTiles.isNotEmpty) ...[
              _SettingsGroup(
                title: 'NOTIFICATIONS',
                children: notificationsTiles,
              ),
              const SizedBox(height: 16),
            ],
            if (privacyTiles.isNotEmpty) ...[
              _SettingsGroup(title: 'PRIVACY', children: privacyTiles),
              const SizedBox(height: 16),
            ],
            if (sessionTiles.isNotEmpty) ...[
              _SettingsGroup(title: '', children: sessionTiles),
              const SizedBox(height: 16),
            ],
          ] else ...[
            // No Results Placeholder
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 48,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: AppColors.outline.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We couldn't find any settings matching '$searchQuery'",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      icon: const Icon(Icons.clear, size: 18),
                      label: const Text(
                        'Clear Search',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.08,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        ref.read(settingsSearchQueryProvider.notifier).state =
                            '';
                        ref
                                .read(isSettingsSearchActiveProvider.notifier)
                                .state =
                            false;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Footer
          if (hasResults) ...[
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _FooterLink(label: 'TERMS OF USE', onTap: () {}),
                      const SizedBox(width: 16),
                      _FooterLink(label: 'HELP CENTER', onTap: () {}),
                      const SizedBox(width: 16),
                      _FooterLink(label: 'CONTACT US', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'VERSION 2.4.0 (BUILD 108)',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 80), // bottom nav padding
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditProfileBottomSheet(),
    );
  }

  void _showMockDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerlowest,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final activeLang = ref.read(settingsProvider).language;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerlowest,
        title: const Text(
          'Language/Region',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'ASL'].map((lang) {
            final isSelected = activeLang == lang;
            return ListTile(
              title: Text(
                lang,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                  : null,
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage(lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSensitivitySelector(BuildContext context, WidgetRef ref) {
    final activeSens = ref.read(settingsProvider).sensitivity;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerlowest,
        title: const Text(
          'Sensitivity',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Low', 'Medium', 'High'].map((sens) {
            final isSelected = activeSens == sens;
            return ListTile(
              title: Text(
                sens,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                  : null,
              onTap: () {
                ref.read(settingsProvider.notifier).setSensitivity(sens);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTextSizeSelector(BuildContext context, WidgetRef ref) {
    final activeSize = ref.read(settingsProvider).textSize;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerlowest,
        title: const Text(
          'Text size',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Small', 'Default', 'Large'].map((size) {
            final isSelected = activeSize == size;
            return ListTile(
              title: Text(
                size,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                  : null,
              onTap: () {
                ref.read(settingsProvider.notifier).setTextSize(size);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerlowest,
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out from MuteMate?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully logged out.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerlowest,
        title: const Text(
          'Delete Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your progress, XP, and learning history will be deleted forever.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickToggleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _QuickToggleCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          _MuteMateMiniSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _MuteMateSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MuteMateSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value
              ? AppColors.primary
              : AppColors.outline.withValues(alpha: 0.3),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _MuteMateMiniSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _MuteMateMiniSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 20,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: value
              ? AppColors.primary
              : AppColors.outline.withValues(alpha: 0.3),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerlowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: AppColors.surfaceContainerLow,
            ),
            itemBuilder: (context, index) => children[index],
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final Color? iconColor;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.titleColor,
    this.iconColor,
    this.trailing,
    this.showChevron = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  iconColor ??
                  AppColors.onSurfaceVariant.withValues(alpha: 0.7),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? AppColors.onSurface,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null && showChevron)
              Icon(
                Icons.chevron_right,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
