import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:camera/camera.dart';

class CameraTranslationPage extends StatefulWidget {
  const CameraTranslationPage({super.key});

  @override
  State<CameraTranslationPage> createState() => _CameraTranslationPageState();
}

class _CameraTranslationPageState extends State<CameraTranslationPage> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) return;

      _controller = CameraController(
        _cameras[_cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() => _isReady = true);
      }
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _controller?.dispose();

    _controller = CameraController(
      _cameras[_cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LIVE CAMERA
          Positioned.fill(
            child: _isReady && _controller != null
                ? CameraPreview(_controller!)
                : const Center(
                    child: CircularProgressIndicator(color: Colors.tealAccent),
                  ),
          ),

          // TOP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RoundGlassButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Sign to Speech',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'RECOGNIZING',
                            style: TextStyle(
                              color: Colors.tealAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _RoundGlassButton(
                          icon: Icons.flip_camera_ios_outlined,
                          onTap: _switchCamera,
                        ),
                        const SizedBox(width: 8),
                        _RoundGlassButton(icon: Icons.help_outline),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // LIVE DETECTION CHIP
          Positioned(
            bottom: 280,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT SIGN',
                          style: TextStyle(
                            color: Colors.teal.shade300,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Hello',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '98% Stable',
                          style: TextStyle(
                            color: Colors.teal.shade300,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: _PhraseBuilderTray(),
          ),
        ],
      ),
    );
  }
}

//
// ======================= UI COMPONENTS =======================
//

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
          color: Colors.black.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
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
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: const [
              _PhraseChip(label: 'Hello'),
              _PhraseChip(label: 'how'),
              _PhraseChip(label: 'are'),
              _PhraseChip(label: 'you'),
              _Cursor(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              _ControlAction(icon: Icons.backspace_outlined),
              SizedBox(width: 12),
              _ControlAction(icon: Icons.delete_outline),
              SizedBox(width: 12),
              Expanded(child: _SpeakButton()),
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
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
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
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: Colors.black54),
    );
  }
}

class _SpeakButton extends StatelessWidget {
  const _SpeakButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF004D40)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volume_up, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Speak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
