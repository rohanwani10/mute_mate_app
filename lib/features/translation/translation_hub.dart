import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/app_theme.dart';
import '../../shared/widgets/pill_slider.dart';

enum TranslationMode { signToSpeech, speechToSign }

final translationModeProvider = StateProvider<TranslationMode>(
  (ref) => TranslationMode.speechToSign,
);

class TranslationHub extends ConsumerStatefulWidget {
  const TranslationHub({super.key});

  @override
  ConsumerState<TranslationHub> createState() => _TranslationHubState();
}

class _TranslationHubState extends ConsumerState<TranslationHub> {
  late stt.SpeechToText _speech;
  bool _speechInitialized = false;
  bool _isListening = false;
  late TextEditingController _textController;
  late FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
    _initSpeech();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    try {
      _speech.stop();
      _speech.cancel();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _initSpeech() async {
    final bool isSupported =
        kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
    if (!isSupported) return;

    try {
      final bool initialized = await _speech.initialize(
        onError: (err) {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        },
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'notListening' && _isListening) {
            setState(() {
              _isListening = false;
            });
          }
        },
      );
      if (mounted) {
        setState(() {
          _speechInitialized = initialized;
        });
      }
    } catch (_) {}
  }

  void _toggleListening() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      try {
        await _speech.stop();
      } catch (_) {}
    } else {
      if (!_speechInitialized) {
        await _initSpeech();
        if (!_speechInitialized) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Speech recognition is not available on this device.',
                ),
              ),
            );
          }
          return;
        }
      }

      setState(() {
        _isListening = true;
      });

      try {
        await _speech.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                _textController.text = result.recognizedWords;
                _textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _textController.text.length),
                );
              });
            }
          },
          listenOptions: stt.SpeechListenOptions(
            listenMode: stt.ListenMode.search,
            partialResults: true,
          ),
        );
      } catch (_) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(translationModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _RoundGlassButton(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.pop(context),
                          ),

                          const Text(
                            'Sign to Speech',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ),

                // Mode Switcher
                Center(
                  child: SizedBox(
                    width: 280,
                    child: MuteMateSlidingPill(
                      labels: const ['Sign to Speech', 'Speech to Sign'],
                      selectedIndex: mode == TranslationMode.signToSpeech
                          ? 0
                          : 1,
                      onSegmentChosen: (index) {
                        ref
                            .read(translationModeProvider.notifier)
                            .state = index == 0
                            ? TranslationMode.signToSpeech
                            : TranslationMode.speechToSign;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Sign Result / Avatar Viewer
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 40,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Stack(
                        children: [
                          Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuC5oQipSyu-ZAttz_hhk64MVgNBrYQCSHKDCXUxtYBZUVVpDDLzV44Z2MgD5QPPnqsuoiSJWA2eXMBcAtG-gHRMFXQA9pvnQmLbE9rpqwowNZusSceT878LnzkHvKxFj8i21og10RCLnb2SdAj_1KgdrqTFbsajvPJ8w2HzLsHcLIgarm02NHOdTPymG8mzqLZCZMpoKpxAJSC_0m9eaWCadaNKXteaNfkg8SmD0q0rSDGdE9318G4XHjwEXp-jUWnjqfnr7j6IqiBI',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Row(
                              children: [
                                _CircularControlButton(icon: Icons.replay),
                                const SizedBox(width: 8),
                                _CircularControlButton(icon: Icons.speed),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Sequence Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SIGN SEQUENCE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Clear all',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SignChip(label: 'Hello', isActive: true),
                        _SignChip(label: 'How'),
                        _SignChip(label: 'Are'),
                        _SignChip(label: 'You'),
                        _AddWordButton(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Speech Input Area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.black12, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'SPEECH INPUT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.grey,
                            ),
                          ),
                          const Icon(
                            Icons.volume_up,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _textController,
                        focusNode: _textFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          hintText:
                              'Tap the mic or type a sentence to start translating.',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _WiderMicButton(
                            onTap: _toggleListening,
                            isListening: _isListening,
                          ),
                          Row(
                            children: [
                              _SmallIconButton(
                                icon: Icons.keyboard_alt_outlined,
                                onTap: () {
                                  _textFocusNode.requestFocus();
                                },
                              ),
                              const SizedBox(width: 8),
                              _SmallIconButton(
                                icon: Icons.delete_outline,
                                onTap: () =>
                                    setState(() => _textController.clear()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tip Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.tips_and_updates,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Did you know?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'You can save common phrases for offline use.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundGlassButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.black, size: 24),
    );
  }
}

class _CircularControlButton extends StatelessWidget {
  final IconData icon;
  const _CircularControlButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
        ],
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
    );
  }
}

class _SignChip extends StatelessWidget {
  final String label;
  final bool isActive;
  const _SignChip({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(99),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.close,
            size: 14,
            color: isActive ? Colors.white70 : Colors.black26,
          ),
        ],
      ),
    );
  }
}

class _AddWordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Text(
        '+ Add Word',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _WiderMicButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isListening;

  const _WiderMicButton({required this.onTap, required this.isListening});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 120,
        height: 56,
        decoration: BoxDecoration(
          color: isListening ? AppColors.primary : AppColors.secondary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: (isListening ? AppColors.primary : AppColors.secondary)
                  .withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            isListening ? Icons.stop : Icons.mic,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _SmallIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black54, size: 20),
      ),
    );
  }
}
