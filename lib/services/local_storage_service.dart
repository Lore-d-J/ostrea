import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _progressPrefix = 'progress_';
  static const String _completedModulesKey = 'completed_modules';
  static const String _bookmarksKey = 'bookmarks';

  /// Save module progress
  static Future<void> saveModuleProgress(String moduleId, int progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_progressPrefix$moduleId', progress);
  }

  /// Get module progress
  static Future<int?> getModuleProgress(String moduleId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_progressPrefix$moduleId');
  }

  /// Mark module as completed
  static Future<void> completeModule(String moduleId) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_completedModulesKey) ?? [];
    if (!completed.contains(moduleId)) {
      completed.add(moduleId);
      await prefs.setStringList(_completedModulesKey, completed);
    }
  }

  /// Get all completed modules
  static Future<List<String>> getCompletedModules() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedModulesKey) ?? [];
  }

  /// Add bookmark
  static Future<void> addBookmark(String contentId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    if (!bookmarks.contains(contentId)) {
      bookmarks.add(contentId);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  /// Remove bookmark
  static Future<void> removeBookmark(String contentId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove(contentId);
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  /// Get all bookmarks
  static Future<List<String>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

  /// Check if content is bookmarked
  static Future<bool> isBookmarked(String contentId) async {
    final bookmarks = await getBookmarks();
    return bookmarks.contains(contentId);
  }

  /// Clear all data (useful for testing)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
