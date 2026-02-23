import 'package:flutter/services.dart';
// localization_service no longer required here; app language is fixed to Tagalog

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  static const platform = MethodChannel('com.ostrea.app/tts');
  bool _isInitialized = false;
  // No longer store localization service; app language is Tagalog-only

  factory TextToSpeechService() {
    return _instance;
  }

  TextToSpeechService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      // Use native Android TTS through method channel — always Tagalog (fil)
      await platform.invokeMethod('speak', {
        'text': text,
        'language': 'fil',
      });
    } catch (e) {
      print('TTS Error: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    try {
      await platform.invokeMethod('stop');
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> pause() async {
    try {
      await platform.invokeMethod('pause');
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      // App only supports Tagalog; ensure native TTS uses Tagalog
      await platform.invokeMethod('setLanguage', {'language': 'fil'});
    } catch (e) {
      // Handle error silently
    }
  }

  void dispose() {
    // Cleanup
  }
}
