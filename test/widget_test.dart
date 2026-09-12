// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ostrea/main.dart';
import 'package:ostrea/localization/app_strings.dart';
import 'package:ostrea/localization/app_strings_helper.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/screens/learning_module_screen.dart';
import 'package:ostrea/theme/app_theme.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const OstreaApp());
    expect(find.text(AppStringsHelper.homeTitle), findsOneWidget);
  });

  test('dark theme exposes the requested palette and brightness', () {
    final darkTheme = AppTheme.getDarkTheme();

    expect(darkTheme.brightness, Brightness.dark);
    expect(darkTheme.colorScheme.primary, const Color(0xFF111313));
    expect(darkTheme.colorScheme.secondary, const Color(0xFF1C2020));
    expect(darkTheme.colorScheme.tertiary, const Color(0xFF11D5B4));
    expect(darkTheme.colorScheme.error, const Color(0xFFC43838));
  });

  testWidgets('pressing OK on a completed module pops back to the module list', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final module = LearningModule(
      id: 'module1',
      title: 'Sample Module',
      description: 'Sample description',
      contentSections: ['Only one section'],
      imageAsset: null,
      videoAsset: null,
      hasVoiceNarration: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LearningModuleScreen(module: module),
                    ),
                  );
                },
                child: const Text('open module'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open module'));
    await tester.pumpAndSettle();

    expect(find.byType(LearningModuleScreen), findsOneWidget);
    await tester.tap(find.text(AppStrings.ok));
    await tester.pumpAndSettle();

    expect(find.byType(LearningModuleScreen), findsNothing);
  });
}
