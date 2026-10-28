import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ostrea/services/audio_playback_service.dart';
import 'package:ostrea/utils/narration_sentence_timing.dart';

class AudioNarrationText extends StatefulWidget {
  final String audioId;
  final String text;
  final String? narrationText;
  final int sentenceOffset;
  final TextStyle? style;
  final TextAlign textAlign;

  const AudioNarrationText({
    super.key,
    required this.audioId,
    required this.text,
    this.narrationText,
    this.sentenceOffset = 0,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  State<AudioNarrationText> createState() => _AudioNarrationTextState();
}

class _AudioNarrationTextState extends State<AudioNarrationText> {
  final AudioPlaybackService _audioService = AudioPlaybackService();
  StreamSubscription<String?>? _activeSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  String? _activeAudioId;
  Duration _position = Duration.zero;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _activeAudioId = _audioService.activeAudioId;
    _position = _audioService.position;
    _duration = _audioService.duration;
    _activeSubscription = _audioService.activeAudioStream.listen((audioId) {
      if (!mounted) return;
      setState(() {
        _activeAudioId = audioId;
        if (audioId != widget.audioId) {
          _position = Duration.zero;
          _duration = null;
        }
      });
    });
    _positionSubscription = _audioService.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
    _durationSubscription = _audioService.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });
  }

  @override
  void didUpdateWidget(covariant AudioNarrationText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioId != widget.audioId ||
        oldWidget.text != widget.text ||
        oldWidget.narrationText != widget.narrationText ||
        oldWidget.sentenceOffset != widget.sentenceOffset) {
      _position = _audioService.position;
      _duration = _audioService.duration;
      _activeAudioId = _audioService.activeAudioId;
    }
  }

  @override
  void dispose() {
    _activeSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final narration = widget.narrationText ?? widget.text;
    final activeSentence = _activeAudioId == widget.audioId
        ? narrationSentenceAtPosition(narration, _position, _duration)
        : null;
    final ranges = narrationSentenceRanges(widget.text);
    final highlight = Theme.of(context).colorScheme.secondaryContainer;
    final spans = <InlineSpan>[];
    var cursor = 0;

    for (var index = 0; index < ranges.length; index++) {
      final range = ranges[index];
      if (range.start > cursor) {
        spans.add(TextSpan(text: widget.text.substring(cursor, range.start)));
      }
      spans.add(
        TextSpan(
          text: widget.text.substring(range.start, range.end),
          style: activeSentence == widget.sentenceOffset + index
              ? TextStyle(backgroundColor: highlight.withValues(alpha: 0.8))
              : null,
        ),
      );
      cursor = range.end;
    }
    if (cursor < widget.text.length) {
      spans.add(TextSpan(text: widget.text.substring(cursor)));
    }

    return Text.rich(
      TextSpan(style: widget.style, children: spans),
      textAlign: widget.textAlign,
    );
  }
}