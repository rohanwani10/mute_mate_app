import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import '../../shared/widgets/pill_slider.dart';

enum TranslationMode { signToSpeech, speechToSign }

final translationModeProvider = StateProvider<TranslationMode>((ref) => TranslationMode.speechToSign);

class TranslationHub extends ConsumerWidget {
  const TranslationHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(translationModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primary),
          onPressed: () {},
        ),
        title: const Text(
          'MuteMate',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.grey),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBt5U5XCJ0NJfl2azxeRDwCtOK09y8_44IuXkUvnFw0mz7fDC8mP2IJboprz47uQsRVmWUyHeI4FiIvOf9WJ6oASPvuXjeDzEjpWdhpyHN3gjDcHDRd4bKWpWr-Egwpvl5lgTY5vteTYGJr6keB0a0rJWGCtIvnkdmQAwAUN68yKNGQc4k0e6iM4ueX-cbOna8VQDTbv3VMKMgjCIJqCiS_e3UbqBbQiGWPBavEtg9I_vrK43NdZLiYTEVclDtkPqgrm0b1Lr8BLAAF'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Mode Switcher
            Center(
              child: SizedBox(
                width: 280,
                child: MuteMateSlidingPill(
                  labels: const ['Sign to Speech', 'Speech to Sign'],
                  selectedIndex: mode == TranslationMode.signToSpeech ? 0 : 1,
                  onSegmentChosen: (index) {
                    ref.read(translationModeProvider.notifier).state =
                        index == 0 ? TranslationMode.signToSpeech : TranslationMode.speechToSign;
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
                      color: Colors.black.withOpacity(0.03),
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
                      child: const Text('Clear all', style: TextStyle(fontSize: 12)),
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
                      const Icon(Icons.volume_up, color: AppColors.primary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tap the mic or type a sentence to start translating.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _WiderMicButton(),
                      Row(
                        children: [
                          _SmallIconButton(icon: Icons.keyboard_alt_outlined),
                          const SizedBox(width: 8),
                          _SmallIconButton(icon: Icons.delete_outline),
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
                color: const Color(0xFFE0F2F1).withOpacity(0.5),
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
                    child: const Icon(Icons.tips_and_updates, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Did you know?',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        Text(
                          'You can save common phrases for offline use.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
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
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
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
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
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
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}

class _WiderMicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.mic, color: Colors.white, size: 28),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  const _SmallIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black26, size: 20),
    );
  }
}
