import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ostrea/services/local_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('refreshes stale bundled content while preserving user progress', () async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('built_in_content_version', 1);
    await prefs.setString(
      'learning_modules',
      '{"old":true}',
    );
    await prefs.setString(
      'dictionary_entries',
      '{"old":true}',
    );
    await prefs.setStringList('completed_modules', ['module1']);
    await prefs.setInt('progress_module1', 2);

    await LocalDataService().initializeContent();

    final refreshedModules = prefs.getString('learning_modules');
    final refreshedDictionary = prefs.getString('dictionary_entries');
    final savedVersion = prefs.getInt('built_in_content_version');

    expect(savedVersion, LocalDataService.currentContentVersion);
    expect(refreshedModules, isNotNull);
    expect(refreshedDictionary, isNotNull);
    expect(refreshedModules, contains('module1'));
    expect(refreshedDictionary, contains('Pamiitan'));
    expect(prefs.getStringList('completed_modules'), ['module1']);
    expect(prefs.getInt('progress_module1'), 2);
  });

  test('stores default content on fresh install', () async {
    final prefs = await SharedPreferences.getInstance();

    await LocalDataService().initializeContent();

    expect(prefs.getString('learning_modules'), isNotNull);
    expect(prefs.getString('troubleshooting_guides'), isNotNull);
    expect(prefs.getString('dictionary_entries'), isNotNull);
    expect(prefs.getInt('built_in_content_version'), LocalDataService.currentContentVersion);
  });
}
