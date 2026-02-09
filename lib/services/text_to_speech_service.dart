import 'package:flutter/services.dart';
import 'package:ostrea/services/localization_service.dart';

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  static const platform = MethodChannel('com.ostrea.app/tts');
  bool _isInitialized = false;
  late LocalizationService _localizationService;

  factory TextToSpeechService() {
    return _instance;
  }

  TextToSpeechService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    _localizationService = LocalizationService();
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      // Use native Android TTS through method channel
      final language = _localizationService.currentLanguage == 'en' ? 'en' : 'fil';
      await platform.invokeMethod('speak', {
        'text': text,
        'language': language,
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
      await platform.invokeMethod('setLanguage', {
        'language': languageCode == 'en' ? 'en' : 'fil',
      });
    } catch (e) {
      // Handle error silently
    }
  }

  void dispose() {
    // Cleanup
  }
}
