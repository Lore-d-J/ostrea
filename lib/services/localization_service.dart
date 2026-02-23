import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  static const String _languageKey = 'app_language';
  String _currentLanguage = 'tl'; // Default to Tagalog

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? 'tl';
    // Ensure the stored language is Tagalog only
    if (_currentLanguage != 'tl') {
      _currentLanguage = 'tl';
      await prefs.setString(_languageKey, 'tl');
    }
  }

  String get currentLanguage => _currentLanguage;

  Future<void> setLanguage(String languageCode) async {
    // App supports only Tagalog now; ignore requested language and keep 'tl'.
    _currentLanguage = 'tl';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, 'tl');
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'tl':
        return 'Tagalog';
      default:
        return 'Unknown';
    }
  }
}
