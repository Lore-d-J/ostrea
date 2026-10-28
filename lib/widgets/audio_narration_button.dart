import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ostrea/services/audio_playback_service.dart';

class AudioNarrationButton extends StatefulWidget {
  final String audioId;
  final String assetPath;
  final String tooltip;

  const AudioNarrationButton({
    super.key,
    required this.audioId,
    required this.assetPath,
    required this.tooltip,
  });

  @override
  State<AudioNarrationButton> createState() => _AudioNarrationButtonState();
}

class _AudioNarrationButtonState extends State<AudioNarrationButton> {
  final AudioPlaybackService _audioService = AudioPlaybackService();
  StreamSubscription<String?>? _activeSubscription;
  String? _activeAudioId;

  bool get _isPlaying => _activeAudioId == widget.audioId;

  @override
  void initState() {
    super.initState();
    _activeAudioId = _audioService.activeAudioId;
    _activeSubscription = _audioService.activeAudioStream.listen((audioId) {
      if (mounted) setState(() => _activeAudioId = audioId);
    });
  }

  @override
  void didUpdateWidget(covariant AudioNarrationButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioId != widget.audioId) {
      _activeAudioId = _audioService.activeAudioId;
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioService.stop();
      return;
    }

    final succeeded = await _audioService.playRecordedAudio(
      widget.assetPath,
      widget.audioId,
    );
    if (!succeeded && mounted && _audioService.activeAudioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hindi makita ang audio file: ${widget.assetPath}')),
      );
    }
  }

  @override
  void dispose() {
    _activeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: _togglePlayback,
      tooltip: _isPlaying ? 'Itigil ang ${widget.tooltip}' : widget.tooltip,
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      padding: EdgeInsets.zero,
      color: _isPlaying ? colorScheme.primary : colorScheme.onSurfaceVariant,
      icon: Icon(
        _isPlaying ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
        size: 24,
      ),
    );
  }
}