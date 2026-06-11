import 'package:flutter/material.dart';
import '../../features/translation/camera_translation_page.dart';
import '../../features/translation/translation_hub.dart';

class QuickActionsBottomSheet extends StatelessWidget {
  const QuickActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F8).withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(48),
        ), // Your preferred radius
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔹 Drag Handle
              Container(
                width: 48,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              /// 🔹 Title Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select an action to get started immediately",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 Actions List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    QuickActionTile(
                      icon: Icons.translate_outlined,
                      title: "Start Sign to Speech",
                      subtitle: "Real-time camera translation",
                      isPrimary: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CameraTranslationPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    QuickActionTile(
                      icon: Icons.mic_none_outlined,
                      title: "Start Speech to Sign",
                      subtitle: "Voice to visual signing",
                      isPrimary: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TranslationHub(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    QuickActionTile(
                      icon: Icons.history,
                      title: "Resume last lesson",
                      subtitle: "Pick up where you left off",
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    QuickActionTile(
                      icon: Icons.star,
                      title: "Today's Challenge",
                      subtitle: "Earn bonus streak points",
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// 🔹 Dismiss Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Dismiss",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isPrimary;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              /// Icon Box
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isPrimary
                      ? const Color(0xFF89F5E7) // primary-fixed
                      : const Color(0xFFFFDBCA), // secondary-fixed
                  borderRadius: BorderRadius.circular(500),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isPrimary
                      ? const Color(0xFF00685F)
                      : const Color(0xFF9D4300),
                ),
              ),

              const SizedBox(width: 16),

              /// Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              /// Arrow
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFD6D3D1),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
