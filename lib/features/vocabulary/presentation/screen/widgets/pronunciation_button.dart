import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// NOTE: assumes core/theme/app_colors.dart — adjust this path if your
// theme files live somewhere else in the project.
import 'package:hollandkompas/core/services/tts/tts_providers.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

/// The one "Audio Playback" button used everywhere Dutch text needs to
/// be spoken — a vocabulary word, an example sentence, or any future
/// Dutch text inside a lesson. Always goes through [ttsServiceProvider],
/// never creates its own TTS instance.
class PronunciationButton extends ConsumerStatefulWidget {
  const PronunciationButton({
    super.key,
    required this.text,
    this.size = 22,
  });

  final String text;
  final double size;

  @override
  ConsumerState<PronunciationButton> createState() => _PronunciationButtonState();
}

class _PronunciationButtonState extends ConsumerState<PronunciationButton> {
  bool _isPlaying = false;

  Future<void> _handleTap() async {
    final tts = ref.read(ttsServiceProvider);
    setState(() => _isPlaying = true);
    await tts.speak(widget.text);
    // flutter_tts's completion handler updates isSpeaking asynchronously;
    // a short poll keeps the icon in sync without needing a stream.
    while (mounted && tts.isSpeaking) {
      await Future.delayed(const Duration(milliseconds: 150));
    }
    if (mounted) setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'استمع للنطق',
      onPressed: widget.text.trim().isEmpty ? null : _handleTap,
      icon: Icon(
        _isPlaying ? Icons.volume_up_rounded : Icons.volume_up_outlined,
        size: widget.size,
        color: AppColors.primary,
      ),
    );
  }
}
