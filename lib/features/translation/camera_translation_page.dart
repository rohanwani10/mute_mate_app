import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class CameraTranslationPage extends StatelessWidget {
  const CameraTranslationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Viewport Placeholder
          Positioned.fill(
            child: Opacity(
              opacity: 0.8,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBSHr-xR8e82ojvzLE1ySj0mpRluAnma1RqHS0rlJdM8TMtR0H9-QaoYPCXhmGZ3PiKStYpvyYFNO_UzsF86j10oh8U1zTfD02MsG7zCdLRpgxP_E7t4L_M2LeYM5wtpNn3p7gLRCvehh38D8peI0Jz0Y3pWvlbz1wegD16AFkIrFTO6ROnCFUrIhkrATlsjAJaigKsnY3ZOf6HwEDinlOr1mIblxHkJjb2jnnzCdpuECsdIQPYumkyVf_jLYt8MGyVjeZWSPt8B1wL',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // AI Skeletal Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _HandSkeletonPainter(),
            ),
          ),

          // Top Bar Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RoundGlassButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                    Column(
                      children: [
                        const Text(
                          'Sign to Speech',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _PulsePoint(),
                              SizedBox(width: 8),
                              Text(
                                'RECOGNIZING',
                                style: TextStyle(color: Colors.tealAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _RoundGlassButton(icon: Icons.flip_camera_ios_outlined),
                        const SizedBox(width: 8),
                        _RoundGlassButton(icon: Icons.help_outline),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Live Detection Chip
          Positioned(
            bottom: 280,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT SIGN',
                          style: TextStyle(color: Colors.teal.shade300, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                        const Text(
                          'Hello',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Container(width: 1, height: 40, color: Colors.white12),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'CONFIDENCE',
                          style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                        Text(
                          '98% Stable',
                          style: TextStyle(color: Colors.teal.shade300, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Phrase Builder Tray
          const Align(
            alignment: Alignment.bottomCenter,
            child: _PhraseBuilderTray(),
          ),
        ],
      ),
    );
  }
}

class _HandSkeletonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.tealAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.tealAccent
      ..style = PaintingStyle.fill;

    // Simulate hand points
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.6;

    final points = [
      Offset(centerX, centerY),
      Offset(centerX - 40, centerY - 40),
      Offset(centerX - 60, centerY - 100),
      Offset(centerX + 40, centerY - 40),
      Offset(centerX + 60, centerY - 100),
    ];

    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }

    // Connect them
    final path1 = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[2].dx, points[2].dy);
    
    final path2 = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..lineTo(points[4].dx, points[4].dy);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoundGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _RoundGlassButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            color: Colors.white10,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}

class _PulsePoint extends StatefulWidget {
  const _PulsePoint();
  @override
  State<_PulsePoint> createState() => _PulsePointState();
}

class _PulsePointState extends State<_PulsePoint> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: Colors.tealAccent, shape: BoxShape.circle),
      ),
    );
  }
}

class _PhraseBuilderTray extends StatelessWidget {
  const _PhraseBuilderTray();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, -10)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20)),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PhraseChip(label: 'Hello'),
                _PhraseChip(label: 'how'),
                _PhraseChip(label: 'are'),
                _PhraseChip(label: 'you'),
                const _Cursor(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _ControlAction(icon: Icons.backspace_outlined),
              const SizedBox(width: 12),
              _ControlAction(icon: Icons.delete_outline),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF004D40)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_up, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Speak', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhraseChip extends StatelessWidget {
  final String label;
  const _PhraseChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(99)),
      child: Text(label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
    );
  }
}

class _Cursor extends StatelessWidget {
  const _Cursor();
  @override
  Widget build(BuildContext context) {
    return Container(width: 2, height: 24, color: Colors.teal);
  }
}

class _ControlAction extends StatelessWidget {
  final IconData icon;
  const _ControlAction({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
      child: Icon(icon, color: Colors.black54),
    );
  }
}
