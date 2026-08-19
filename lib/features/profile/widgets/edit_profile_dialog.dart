import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../providers/profile_provider.dart';

class EditProfileBottomSheet extends ConsumerStatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  ConsumerState<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends ConsumerState<EditProfileBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _selectedAvatar;

  final List<String> _avatars = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBAuS3urnxYXYkUNxfhTt4PXoEU7hLU3aiEgPM2KghcgO6clgCNmGjhphYYgt7VRR-z_mXQNcwIp2YQwAEN_DrwlYT2eJfnkYiWjskfR12VeIFk8AlV9aowRcNlKmVSVemPtI-Qv1ks2OExa8xRKYZmp4S3fsew4hdwEwtIFS37DSX3rL-xPcZucB9UgzV2fTsUoX0ToOjRTiTQC9yqjOqOH6ONZ9bllgSuevn_Th4_QRMXSjZbLlbtdk47RP-ugrJRm9btOCCGUVge',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuByu_KxIX-KyCgjEaWGDeERqP5oe5FwORfqNSWH3nxMtglqqoYQsj7hBCPnT7wgethh58QldXwsFqUVAh3ZgGsfq27bUgFHfpAHCvhysNXQmxVy7_lck5CnwU_IGOgUgnV6TICkNchL4gaONxmIEsvzdJWm0fgX10y4wuYwzvoNaXofdMkG_ABPeX1YEtuZ4Pb3bachqoh8tvdi3cA7ZRZ7UrZDeVJvIhGz5zoxn3U7DkE6dWNOT3cF2jUG4SzL86ynx8bSfM9oPfq_',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAMocZ4tIeVHX_69_miMWxPPnNapVjjnQIYmGwED9YtqwVo4stUBZgUODm9Kghg8Y_evVnaAFdI13HzCVCt7w9nnbd9x9gF941EoVzSssGD5bhapliOVXMCRyACddE1ZdQEkt5LzQ8jm4bdLu6w1vjrie75WcMt6Lsprr-JdhlUaNxwI4TLs4f4FVYQ7u46q-sIqGJfHNoZExs-7muau_okTrlg1YfE9Q-Mp5A5T164-Yeq8opVGFJc7_v3e9UP1_bHhIf3u69mEkhK',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBNhu4hiqDFNsH0SizPQSRtZzvdt--YdFze8jUacoL1n0Cu2ceUJBDRHxwKGWwtH6ElfXWnT_9vjQISL_eg55wMVMOQUmNY6Dk22drvhCwgqAirtJzc8wrVGwXsnJ4tPzRsTI0BerUKTKs-_b18pzvOpX1LgUWixz-4Q81e_xBbJAcrtlBr0j39QDP9jw-2jZjCzXMoCgJ2efgSJ2oCTKF4ta42BKu3baJNIPN7CO0wTMc6S75pvsrkN9vRn4p_wgx9KQujdfw0pxd3',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _selectedAvatar = profile.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerlowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'CHOOSE AVATAR',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _avatars.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final avatar = _avatars[index];
                  final isSelected = _selectedAvatar == avatar;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = avatar;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: CachedNetworkImageProvider(avatar),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: const TextStyle(color: AppColors.outline),
                floatingLabelStyle: const TextStyle(color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: const TextStyle(color: AppColors.outline),
                floatingLabelStyle: const TextStyle(color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.outline),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newName = _nameController.text.trim();
                      final newEmail = _emailController.text.trim();
                      if (newName.isNotEmpty && newEmail.isNotEmpty) {
                        final handle = '@${newName.toLowerCase().replaceAll(' ', '')}';
                        ref.read(profileProvider.notifier).updateProfile(
                              name: newName,
                              email: newEmail,
                              username: handle,
                              avatarUrl: _selectedAvatar,
                            );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
