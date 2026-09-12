import 'dart:async';
import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

class AudioPlaybackService {
  static final AudioPlaybackService _instance =
      AudioPlaybackService._internal();

  factory AudioPlaybackService() => _instance;

  AudioPlaybackService._internal() {
    _setupListeners();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();
  final StreamController<String?> _activeAudioController =
      StreamController<String?>.broadcast();
  bool _isPlaying = false;
  String? _activeAudioId;

  void _setupListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      final isPlayingNow = state == PlayerState.playing;
      _isPlaying = isPlayingNow;
      if (!isPlayingNow) _activeAudioId = null;
      if (!_playingController.isClosed) _playingController.add(isPlayingNow);
      if (!isPlayingNow && !_activeAudioController.isClosed) {
        _activeAudioController.add(null);
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _activeAudioId = null;
      if (!_playingController.isClosed) _playingController.add(false);
      if (!_activeAudioController.isClosed) _activeAudioController.add(null);
    });
  }

  Stream<bool> get playingStream => _playingController.stream;
  Stream<String?> get activeAudioStream => _activeAudioController.stream;
  bool get isPlaying => _isPlaying;
  String? get activeAudioId => _activeAudioId;

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

    return await _playAsset(assetPath, 'module:$moduleId:$sectionIndex');
  }

  /// Play troubleshooting guide audio.
  /// File naming: ttsTroubleshoot1.mp3
  Future<bool> playGuide(String guideId) async {
    final match = RegExp(r'(\d+)').firstMatch(guideId);
    final guideNumber = match != null
        ? int.parse(match.group(1)!).toString()
        : guideId;

    final assetPath = 'assets/audio/guides/ttsTroubleshoot$guideNumber.mp3';
    developer.log('playGuide: guideId=$guideId → assetPath=$assetPath');
    return await _playAsset(assetPath, 'guide:$guideId');
  }

  Future<bool> _playAsset(String assetPath, String audioId) async {
    try {
      // audioplayers AssetSource path must NOT include the "assets/" prefix
      final cleanPath = assetPath.replaceFirst('assets/', '');
      developer.log('AudioPlaybackService: playing → $cleanPath');

      // Stop & release current audio before playing new one
      try {
        await _audioPlayer.stop();
      } catch (_) {}

      _isPlaying = true;
      _activeAudioId = audioId;
      if (!_playingController.isClosed) _playingController.add(true);
      if (!_activeAudioController.isClosed) _activeAudioController.add(audioId);

      await _audioPlayer.play(AssetSource(cleanPath));

      developer.log('AudioPlaybackService: successfully started → $cleanPath');
      return true;
    } catch (e, stack) {
      developer.log(
        'AudioPlaybackService: FAILED to play "$assetPath"\nError: $e',
        stackTrace: stack,
      );
      _isPlaying = false;
      _activeAudioId = null;
      if (!_playingController.isClosed) _playingController.add(false);
      if (!_activeAudioController.isClosed) _activeAudioController.add(null);
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    _isPlaying = false;
    _activeAudioId = null;
    if (!_playingController.isClosed) _playingController.add(false);
    if (!_activeAudioController.isClosed) _activeAudioController.add(null);
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (_) {}
    _isPlaying = false;
    _activeAudioId = null;
    if (!_playingController.isClosed) _playingController.add(false);
    if (!_activeAudioController.isClosed) _activeAudioController.add(null);
  }

  Future<void> dispose() async {
    await stop();
  }
}
