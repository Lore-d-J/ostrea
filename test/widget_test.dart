// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ostrea/main.dart';
import 'package:ostrea/localization/app_strings_helper.dart';
import 'package:ostrea/theme/app_theme.dart';

void main() {
  test('requested ocean palette constants are defined in the theme', () {
    expect(AppTheme.primaryColor, const Color(0xFF006D77));
    expect(AppTheme.secondaryColor, const Color(0xFF83C5BE));
    expect(AppTheme.tertiaryColor, const Color(0xFF004D40));
    expect(AppTheme.accentColor, const Color(0xFFFF6B6B));
    expect(AppTheme.backgroundColor, const Color(0xFFF0F4F8));
    expect(AppTheme.surfaceColor, const Color(0xFFFFFFFF));
    expect(AppTheme.errorColor, const Color(0xFFD32F2F));
    expect(AppTheme.warningColor, const Color(0xFFF57F17));
    expect(AppTheme.successColor, const Color(0xFF06A77D));
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const OstreaApp());
    expect(find.text(AppStringsHelper.homeTitle), findsOneWidget);
  });
}
