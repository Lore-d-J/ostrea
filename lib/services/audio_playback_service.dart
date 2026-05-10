import 'dart:async';
import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

class AudioPlaybackService {
  static final AudioPlaybackService _instance = AudioPlaybackService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final StreamController<bool> _playingController = StreamController<bool>.broadcast();
  bool _isPlaying = false;

  factory AudioPlaybackService() {
    return _instance;
  }

  AudioPlaybackService._internal() {
    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _playingController.add(false);
    });
  }

  Stream<bool> get playingStream => _playingController.stream;
  bool get isPlaying => _isPlaying;

  /// Extract module number from moduleId (e.g., "module1" -> "1")
  String _extractModuleNumber(String moduleId) {
    final match = RegExp(r'(\d+)').firstMatch(moduleId);
    if (match != null) {
      return match.group(1)!.replaceFirst(RegExp(r'^0+'), '') ?? '1';
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

  /// Play module section audio
  /// Naming: ttsModule1.mp3 (single section) or ttsModule1Section1.mp3 (multi-section)
  Future<bool> playModuleSection(String moduleId, int sectionIndex) async {
    final moduleNumber = _extractModuleNumber(moduleId);
    final folderName = _getModuleFolderName(moduleId);
    
    // Try multi-section naming first: ttsModule1Section1.mp3
    var assetPath = 'assets/audio/modules/$folderName/ttsModule${moduleNumber}Section${sectionIndex + 1}.mp3';
    return await _playAsset(assetPath);
  }

  /// Play troubleshooting guide audio
  /// Naming: ttsTroubleshoot1.mp3 or use the guide ID directly
  Future<bool> playGuide(String guideId) async {
    // Extract number from guide ID if it contains digits
    final match = RegExp(r'(\d+)').firstMatch(guideId);
    final guideNumber = match?.group(1) ?? guideId;
    
    var assetPath = 'assets/audio/guides/ttsTroubleshoot${guideNumber}.mp3';
    return await _playAsset(assetPath);
  }

  Future<bool> _playAsset(String assetPath) async {
    try {
      developer.log('Attempting to play audio: $assetPath');
      _isPlaying = true;
      _playingController.add(true);
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(assetPath, mimeType: 'audio/mpeg'));
      developer.log('Successfully started playing: $assetPath');
      return true;
    } catch (e) {
      developer.log('Failed to play audio: $assetPath. Error: $e');
      _isPlaying = false;
      _playingController.add(false);
      return false;
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _playingController.add(false);
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _isPlaying = false;
    await _playingController.close();
  }
}
