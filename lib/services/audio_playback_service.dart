import 'dart:async';
import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

class AudioPlaybackService {
  AudioPlayer _audioPlayer = AudioPlayer();
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();
  bool _isPlaying = false;
  bool _isDisposed = false;

  AudioPlaybackService() {
    _setupListeners();
  }

  void _setupListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (_isDisposed) return;

      final isPlayingNow = state == PlayerState.playing;
      _isPlaying = isPlayingNow;
      if (!_playingController.isClosed) _playingController.add(isPlayingNow);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (_isDisposed) return;
      _isPlaying = false;
      if (!_playingController.isClosed) _playingController.add(false);
    });
  }

  Stream<bool> get playingStream => _playingController.stream;
  bool get isPlaying => _isPlaying;

  /// Extract module number from moduleId (e.g., "module_001" -> "1")
  String _extractModuleNumber(String moduleId) {
    final match = RegExp(r'(\d+)').firstMatch(moduleId);
    if (match != null) {
      // Remove leading zeros (e.g., "001" -> "1")
      final num = int.parse(match.group(1)!);
      return num.toString();
    }
    return '1';
  }

  /// Convert module ID to zero-padded folder format (e.g., "module1" -> "module_001")
  String _getModuleFolderName(String moduleId) {
    final match = RegExp(r'(\d+)').firstMatch(moduleId);
    if (match != null) {
      final num = int.parse(match.group(1)!);
      return 'module_${num.toString().padLeft(3, '0')}';
    }
    return moduleId;
  }

  /// Play module section audio.
  /// File naming: ttsModule1Section1.mp3 (for module 1, section 1)
  Future<bool> playModuleSection(String moduleId, int sectionIndex) async {
    final moduleNumber = _extractModuleNumber(moduleId);
    final folderName = _getModuleFolderName(moduleId);

    final assetPath =
        'assets/audio/modules/$folderName/ttsModule${moduleNumber}Section${sectionIndex + 1}.mp3';

    return await _playAsset(assetPath);
  }

  /// Play troubleshooting guide audio.
  /// File naming: ttsTroubleshoot1.mp3
  Future<bool> playGuide(String guideId) async {
    final match = RegExp(r'(\d+)').firstMatch(guideId);
    final guideNumber =
        match != null ? int.parse(match.group(1)!).toString() : guideId;

    final assetPath = 'assets/audio/guides/ttsTroubleshoot$guideNumber.mp3';
    developer.log('playGuide: guideId=$guideId → assetPath=$assetPath');
    return await _playAsset(assetPath);
  }

  Future<bool> _playAsset(String assetPath) async {
    if (_isDisposed) return false;

    try {
      // audioplayers AssetSource path must NOT include the "assets/" prefix
      final cleanPath = assetPath.replaceFirst('assets/', '');
      developer.log('AudioPlaybackService: playing → $cleanPath');

      _isPlaying = true;
      if (!_playingController.isClosed) _playingController.add(true);

      // Stop & release current audio before playing new one
      try {
        await _audioPlayer.stop();
      } catch (_) {}

      await _audioPlayer.play(AssetSource(cleanPath));

      developer.log('AudioPlaybackService: successfully started → $cleanPath');
      return true;
    } catch (e, stack) {
      developer.log(
        'AudioPlaybackService: FAILED to play "$assetPath"\nError: $e',
        stackTrace: stack,
      );
      _isPlaying = false;
      if (!_playingController.isClosed) _playingController.add(false);
      return false;
    }
  }

  Future<void> stop() async {
    if (_isDisposed) return;
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    _isPlaying = false;
    if (!_playingController.isClosed) _playingController.add(false);
  }

  Future<void> pause() async {
    if (_isDisposed) return;
    try {
      await _audioPlayer.pause();
    } catch (_) {}
    _isPlaying = false;
    if (!_playingController.isClosed) _playingController.add(false);
  }

  Future<void> dispose() async {
    _isDisposed = true;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.dispose();
    } catch (_) {}
    if (!_playingController.isClosed) {
      await _playingController.close();
    }
  }
}
