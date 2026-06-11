import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import 'models/learn_models.dart';

class VideoPlayerPage extends ConsumerStatefulWidget {
  final Lesson lesson;
  final String videoPath;

  const VideoPlayerPage({
    required this.lesson,
    required this.videoPath,
    super.key,
  });

  @override
  ConsumerState<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends ConsumerState<VideoPlayerPage> {
  bool _isPlaying = false;
  double _progress = 0.33; // Default 1/3 progress
  bool _isFollowing = false;
  bool _isCompleted = false;

  // Video duration in seconds (5m 24s = 324s)
  final int _totalSeconds = 324;

  String _formatTime(double progress) {
    final int currentSeconds = (progress * _totalSeconds).round();
    final int totalMin = _totalSeconds ~/ 60;
    final int totalSec = _totalSeconds % 60;
    final int currentMin = currentSeconds ~/ 60;
    final int currentSec = currentSeconds % 60;

    final String currentSecStr = currentSec < 10
        ? '0$currentSec'
        : '$currentSec';
    final String totalSecStr = totalSec < 10 ? '0$totalSec' : '$totalSec';

    return '$currentMin:$currentSecStr / $totalMin:$totalSecStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Custom Navigation Bar (No Screen Shell)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.surfaceContainerHigh.withValues(
                          alpha: 0.5,
                        ),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.onSurface,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'MuteMate',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.onSurface,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Video Player Section
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            children: [
                              // Video Thumbnail Image
                              Positioned.fill(
                                child: Image.network(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCtbVaYR5MnOzjASwqxYJAyk9acYYe-FVPMbXs8NlLWEA8calxmLyP8F-QaGuiNoCXglJcGDVDepkRyR9gGnX_LRpAJDpTsAuPgOGCb76TKjz7J-qiemrKgCT-Po1JzdChcttgYZAh47ZJhuIS4ZR6nG6B7XYhg5V_ZEd2tJ8RRba6vYbIwAszJg3oKIlhMmd2qUhto_U37-mnkQB2PgKdrh17hivobjGs1QWsSs_i1XoOfRlmyQvUPc0aEEThRFNYuDCsJSaj5zj2x',
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // Play / Pause Click Overlay
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPlaying = !_isPlaying;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    child: Center(
                                      child: AnimatedScale(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        scale: 1.0,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.9,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: AppColors.onPrimary,
                                            size: 36,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Video Controls overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Progress Seeker Bar
                                      _VideoProgressBar(
                                        progress: _progress,
                                        onChanged: (val) {
                                          setState(() {
                                            _progress = val;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 8),

                                      // Icon Bar
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Left Controls
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _progress =
                                                        (_progress -
                                                                10 /
                                                                    _totalSeconds)
                                                            .clamp(0.0, 1.0);
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.replay_10,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isPlaying = !_isPlaying;
                                                  });
                                                },
                                                child: Icon(
                                                  _isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _progress =
                                                        (_progress +
                                                                10 /
                                                                    _totalSeconds)
                                                            .clamp(0.0, 1.0);
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.forward_10,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Text(
                                                _formatTime(_progress),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Right Controls
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.closed_caption,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 16),
                                              Icon(
                                                Icons.settings,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 16),
                                              Icon(
                                                Icons.fullscreen,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Lesson Title / Description
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.lesson.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          color: AppColors.primary,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.lesson.duration,
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.lesson.description,
                                style: TextStyle(
                                  color: AppColors.onSurfaceVariant.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Highlights Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.stars,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Lesson Highlights',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Grid layout
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.72,
                                children: const [
                                  _HighlightCard(
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDYZZFO9gIOoGlScMMKRvSqQtDHBZpK2gx81cJVwaDPvMhzbwYi_1RJmXzn_1ASeNuoagn6iuuRipsZvQ3sKwueIntpAA--BR2pxUP2NOPRSWGVekR1SjVJVdt0Ng5d5I2NmG2H0RYYJyrBHiQTTOxxY5VrwyWUbFGVASufFqBJf8woXkUQ4SDtemZ6uaoEX6WnfWoq2OT9OQgAT3OhHP20CiqWja5FjCAC4ok3-h7rRTk8EWgf5yhJPbVyvXIecFlLD-B7yyz6Es--',
                                    title: 'Hello',
                                    subtitle: 'The fundamental start',
                                  ),
                                  _HighlightCard(
                                    imageUrl:
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAnQg5d3XiNJf6dJGqBb3p545eVerXfReDNj2JY0BowQMg1PPZ4qt5SbPQ6Xy-WH6IwikEeBFl9kc3Z2MlFHA7K6jf7DXLeDGAEtURggyDtGGaUz3VOf9JimDuGe8W8ZCgDEkLf3RZYudKXxDlEO2_aMraDoIfOswqsiFRk-kVgjT4hdPTYRb_hhal1M60azsC6hMzF7llmeQRFmCLo-N695fLncTwJOMuiDZOIN8JV_pjtH9n2iTaaj8E-TGZK86dPwtZrw6_PuZAK',
                                    title: 'Thank You',
                                    subtitle: 'Showing gratitude',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Wide Highlight Card
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.outline.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.face_retouching_natural,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Facial Expressions',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '"Your face provides the tone of your message. Remember to smile!"',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: AppColors.onSurfaceVariant
                                                  .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Instructor Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerlowest,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.outline.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDn2BlRi7LsHZ4pf7qPRM4cN_evqIxu_DNmkj5HwonRFwp4V-GoszNy3wap5Pk0DbjCQzQVlV1NsZmm8bEbd5shlmKqwJOkrAp66XxGNcIdMrDaY_esDUVQlEZc3k3SrGbW5K7qgkOmZhEuQjKXEa1H2bCP18pAsbKpYAcaAMEMpUsVRXCaX1COMOttZ7X2__WfLSqrjGM4OGDhmT-1_NvZ_Tt5Wt4cW5BfhY9r-WU65G8Oo77cP7Ttv4ddqTP_jf7t9Ogmfj2Z7yhF',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sarah Jenkins',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Master ASL Instructor',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isFollowing = !_isFollowing;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isFollowing
                                        ? AppColors.surfaceContainerHigh
                                        : AppColors.surfaceContainerLow,
                                    foregroundColor: AppColors.primary,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    _isFollowing ? 'Following' : 'Follow',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 80), // Footer spacer
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Fixed Complete Lesson Footer Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.95),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check_circle,
                          color: AppColors.onPrimary,
                        ),
                        label: Text(
                          _isCompleted ? 'Lesson Completed' : 'Complete Lesson',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCompleted
                              ? Colors.teal
                              : AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isCompleted
                            ? null
                            : () {
                                setState(() {
                                  _isCompleted = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Lesson completed! +50 XP Earned! 🎉',
                                    ),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                                Future.delayed(
                                  const Duration(seconds: 1),
                                  () {},
                                );
                              },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _HighlightCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoProgressBar extends StatelessWidget {
  final double progress;
  final ValueChanged<double> onChanged;

  const _VideoProgressBar({required this.progress, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPos = renderBox.globalToLocal(details.globalPosition);
            final double value = (localPos.dx / constraints.maxWidth).clamp(
              0.0,
              1.0,
            );
            onChanged(value);
          },
          onTapDown: (details) {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPos = renderBox.globalToLocal(details.globalPosition);
            final double value = (localPos.dx / constraints.maxWidth).clamp(
              0.0,
              1.0,
            );
            onChanged(value);
          },
          child: Container(
            height: 16,
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Track
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // Played Track
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                // Thumb
                Positioned(
                  left: (progress * constraints.maxWidth) - 6,
                  top: -3,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
