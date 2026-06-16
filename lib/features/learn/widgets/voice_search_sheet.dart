import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/app_theme.dart';

enum VoiceSearchState {
  idle,
  listening,
  processing,
  completed,
  error,
}

class VoiceSearchSheet extends StatefulWidget {
  const VoiceSearchSheet({super.key});

  @override
  State<VoiceSearchSheet> createState() => _VoiceSearchSheetState();
}

class _VoiceSearchSheetState extends State<VoiceSearchSheet> with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool _speechInitialized = false;
  VoiceSearchState _state = VoiceSearchState.idle;
  String _transcript = '';
  String _errorMessage = '';

  late AnimationController _animationController;
  Timer? _typewriterTimer;
  Timer? _navigationTimer;

  // List of fallback suggestions
  final List<String> _suggestions = [
    'Basic Greetings',
    'Family & Friends',
    'Emergency Help',
    'Alphabet A–Z',
    'Numbers',
    'Daily Conversation',
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _initSpeech();
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _navigationTimer?.cancel();
    _animationController.dispose();
    try {
      _speech.stop();
      _speech.cancel();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _initSpeech() async {
    // Check platform compatibility
    final bool isSupported = kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
    if (!isSupported) {
      _setUnsupportedState();
      return;
    }

    try {
      final bool initialized = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );
      if (mounted) {
        setState(() {
          _speechInitialized = initialized;
          if (!initialized) {
            _state = VoiceSearchState.error;
            _errorMessage = 'Speech engine initialization failed.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _speechInitialized = false;
          _state = VoiceSearchState.error;
          _errorMessage = 'Speech recognition is not available.';
        });
      }
    }
  }

  void _setUnsupportedState() {
    setState(() {
      _speechInitialized = false;
      _state = VoiceSearchState.error;
      _errorMessage = 'Voice search is not available on this device.';
    });
  }

  void _onSpeechStatus(String status) {
    if (!mounted) return;
    if (status == 'listening') {
      setState(() {
        _state = VoiceSearchState.listening;
      });
      _animationController.repeat();
    } else if (status == 'notListening') {
      if (_state == VoiceSearchState.listening) {
        _stopAndProcessResult();
      }
    }
  }

  void _onSpeechError(dynamic errorNotification) {
    if (!mounted) return;
    final errorString = errorNotification.errorMsg.toString().toLowerCase();
    
    setState(() {
      _animationController.stop();
      _state = VoiceSearchState.error;
      if (errorString.contains('error_permission') || errorString.contains('permission')) {
        _errorMessage = 'Microphone permission is required for voice search.';
      } else if (errorString.contains('error_no_match') || errorString.contains('no speech')) {
        _errorMessage = 'No speech detected. Please try again.';
      } else {
        _errorMessage = 'An error occurred: ${errorNotification.errorMsg}';
      }
    });
  }

  Future<void> _startListening() async {
    if (!_speechInitialized) {
      // Try initializing again if permission or availability issue is cleared
      await _initSpeech();
      if (!_speechInitialized || _state == VoiceSearchState.error) {
        return;
      }
    }

    setState(() {
      _state = VoiceSearchState.listening;
      _transcript = '';
      _errorMessage = '';
    });
    _animationController.repeat();

    try {
      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          setState(() {
            _transcript = result.recognizedWords;
          });

          if (result.finalResult) {
            _stopAndProcessResult();
          }
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.search,
          partialResults: true,
        ),
      );
    } catch (e) {
      setState(() {
        _state = VoiceSearchState.error;
        _errorMessage = 'Failed to start listening.';
        _animationController.stop();
      });
    }
  }

  Future<void> _stopListening() async {
    _animationController.stop();
    try {
      await _speech.stop();
    } catch (_) {}
  }

  void _stopAndProcessResult() {
    _animationController.stop();
    if (_transcript.trim().isEmpty) {
      setState(() {
        _state = VoiceSearchState.error;
        _errorMessage = 'No speech detected. Please try again.';
      });
      return;
    }

    setState(() {
      _state = VoiceSearchState.processing;
    });

    _navigationTimer = Timer(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() {
          _state = VoiceSearchState.completed;
        });
        Navigator.of(context).pop(_transcript);
      }
    });
  }

  void _selectSuggestion(String suggestion) async {
    // Stop listening if active
    if (_state == VoiceSearchState.listening) {
      await _stopListening();
    }

    setState(() {
      _state = VoiceSearchState.processing;
      _transcript = '';
      _errorMessage = '';
    });
    _animationController.repeat();

    // Premium Typewriter simulation
    int index = 0;
    
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (index < suggestion.length) {
        // Append character by character for smooth typing
        setState(() {
          _transcript = suggestion.substring(0, index + 1);
        });
        index++;
      } else {
        timer.cancel();
        _animationController.stop();
        setState(() {
          _state = VoiceSearchState.completed;
        });
        
        _navigationTimer = Timer(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.of(context).pop(suggestion);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 8,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Voice Search',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Live Transcript & Status Area
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_state == VoiceSearchState.idle)
                        Text(
                          'Tap the mic to start searching',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (_state == VoiceSearchState.listening && _transcript.isEmpty)
                        Text(
                          'Listening...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (_state == VoiceSearchState.error)
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Text(
                          _transcript,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Visualizer & Pulse Button Area
            Center(
              child: SizedBox(
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Pulsing Glow Effects
                    if (_state == VoiceSearchState.listening || _state == VoiceSearchState.processing)
                      ...List.generate(2, (index) {
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final delay = index * 0.5;
                            double progress = _animationController.value + delay;
                            if (progress > 1.0) progress -= 1.0;

                            final double scale = 1.0 + (progress * 0.8);
                            final double opacity = (1.0 - progress) * 0.4;
 
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(alpha: opacity),
                              ),
                              transform: Matrix4.diagonal3Values(scale, scale, 1.0),
                            );
                          },
                        );
                      }),

                    // Sound Equalizer Waves
                    if (_state == VoiceSearchState.listening || _state == VoiceSearchState.processing)
                      Positioned(
                        bottom: 0,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(7, (index) {
                                final double phase = index * 0.4;
                                double value = math.sin((_animationController.value * 2 * math.pi) + phase);
                                if (value < 0) value = -value; // ABS for amplitude

                                final double height = 12 + (36 * value);
                                return Container(
                                  width: 4,
                                  height: height,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0 ? AppColors.primary : AppColors.secondary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),

                    // Main Mic Button
                    Positioned(
                      top: 10,
                      child: GestureDetector(
                        onTap: () {
                          if (_state == VoiceSearchState.listening) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF673AB7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            _state == VoiceSearchState.listening ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Suggestion Chips (Fallback & Fast Actions)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggestions',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ActionChip(
                        label: Text(suggestion),
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.onSurfaceVariant,
                        ),
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : AppColors.surfaceContainerHigh,
                        onPressed: () => _selectSuggestion(suggestion),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                          ),
                        ),
                      );
                    },
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
