import 'package:flutter/services.dart';

/// OFFLINE Text-to-Speech Service for Filipino/Tagalog
/// Uses Android's native TTS engines (Google TTS, Samsung TTS, Pico TTS)
/// No internet connection required - works completely offline
class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  static const MethodChannel _platform = MethodChannel('com.example.ostrea/tts');
  bool _isInitialized = false;

  factory TextToSpeechService() {
    return _instance;
  }

  TextToSpeechService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _platform.invokeMethod('initialize');
      _isInitialized = true;
    } on PlatformException catch (e) {
      throw Exception('Failed to initialize TTS: ${e.message}');
    }
  }

  /// Main function to speak Filipino/Tagalog text with clear pronunciation
  Future<void> speakTagalog(String text) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      await _platform.invokeMethod('speak', {
        'text': text,
        'language': 'tl',
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Legacy speak method for backward compatibility
  Future<void> speak(String text) async {
    await speakTagalog(text);
  }

  Future<void> stop() async {
    try {
      await _platform.invokeMethod('stop');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pause() async {
    try {
      await _platform.invokeMethod('pause');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async {
    try {
      await _platform.invokeMethod('dispose');
      _isInitialized = false;
    } catch (e) {
      rethrow;
    }
  }
}
