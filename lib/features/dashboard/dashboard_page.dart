import 'package:flutter/material.dart';
import '../../shared/widgets/action_card.dart';
import '../../shared/widgets/stat_card.dart';
import '../../core/app_theme.dart';
import './mute_mate_recomendation.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          const Text(
            'Hello, Alex',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Let's Start from where you left..",
            style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Stats Section
          const MuteMateStatCard(
            label: 'Current Streak',
            value: '12 Days',
            icon: Icons.local_fire_department_rounded,
            iconBackgroundColor: AppColors.secondaryIcon,
            iconColor: AppColors.secondary,
          ),
          const SizedBox(height: 8),
          _TotalXPStat(),
          const SizedBox(height: 8),
          _WeeklyTargetStat(),
          const SizedBox(height: 32),

          // Primary Quick Actions
          MuteMateActionCard(
            title: 'Sign to Speech',
            subtitle: 'Real-time translation from hand gestures to audio.',
            icon: Icons.videocam_outlined,
            backgroundColor: AppColors.primary,
            buttonText: 'Start now',
            badgeText: '1 tap start',
            onActionPressed: () {},
          ),
          const SizedBox(height: 16),
          MuteMateActionCard(
            title: 'Speech to Sign',
            subtitle: 'Convert spoken words into visual signing animations.',
            icon: Icons.mic_none_outlined,
            accentColor: AppColors.secondaryMic,
            backgroundColor: AppColors.secondaryContainer,
            buttonText: 'Start now',
            badgeText: '1 tap start',
            onActionPressed: () {},
          ),
          const SizedBox(height: 32),

          // Learning Module
          _LearningModuleBanner(),
          const SizedBox(height: 32),

          // Recommended
          _SectionHeader(title: 'Recommended for you'),
          const SizedBox(height: 16),
          const MuteMateRecommendation(
            title: 'Advanced Facial Expressions',
            subtitle: 'Deepen your signing with nuance.',
            duration: '12:45',
            authorName: 'By Sarah Miller',
            authorImage:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuByu_KxIX-KyCgjEaWGDeERqP5oe5FwORfqNSWH3nxMtglqqoYQsj7hBCPnT7wgethh58QldXwsFqUVAh3ZgGsfq27bUgFHfpAHCvhysNXQmxVy7_lck5CnwU_IGOgUgnV6TICkNchL4gaONxmIEsvzdJWm0fgX10y4wuYwzvoNaXofdMkG_ABPeX1YEtuZ4Pb3bachqoh8tvdi3cA7ZRZ7UrZDeVJvIhGz5zoxn3U7DkE6dWNOT3cF2jUG4SzL86ynx8bSfM9oPfq_',
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBNhu4hiqDFNsH0SizPQSRtZzvdt--YdFze8jUacoL1n0Cu2ceUJBDRHxwKGWwtH6ElfXWnT_9vjQISL_eg55wMVMOQUmNY6Dk22drvhCwgqAirtJzc8wrVGwXsnJ4tPzRsTI0BerUKTKs-_b18pzvOpX1LgUWixz-4Q81e_xBbJAcrtlBr0j39QDP9jw-2jZjCzXMoCgJ2efgSJ2oCTKF4ta42BKu3baJNIPN7CO0wTMc6S75pvsrkN9vRn4p_wgx9KQujdfw0pxd3',
          ),
          const SizedBox(height: 80), // Padding for bottom nav
        ],
      ),
    );
  }
}

class _TotalXPStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MuteMateStatCard(
      label: 'Total XP',
      value: '2,450',
      icon: Icons.stars,
      iconBackgroundColor: AppColors.surfaceContainerHigh,
      iconColor: AppColors.primary,
      trailing: Container(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(
          value: 0.7,
          strokeWidth: 4,
          backgroundColor: AppColors.surfaceContainerHigh,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _WeeklyTargetStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerlowest,
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Target',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Text(
                '85%',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.85,
            backgroundColor: AppColors.surfaceContainerHigh,
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

class _LearningModuleBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.school_outlined,
                size: 16,
                color: AppColors.tertiary,
              ),
              const SizedBox(width: 8),
              const Text(
                'CURRENT UNIT: BASIC GREETINGS',
                style: TextStyle(
                  color: AppColors.tertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Continue where you left off',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Module Progress',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('64%', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.64,
            backgroundColor: AppColors.surfaceContainerHigh,
            color: AppColors.primary,
            minHeight: 12,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
              ),
              child: const Text(
                'Resume',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
