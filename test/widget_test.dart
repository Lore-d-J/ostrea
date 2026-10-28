// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:ostrea/main.dart';
import 'package:ostrea/localization/app_strings_helper.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/screens/about_us_screen.dart';
import 'package:ostrea/screens/learning_module_screen.dart';
import 'package:ostrea/services/image_classifier_service.dart';
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

  test('classifier greenish image heuristic detects green pixels', () {
    final image = img.Image(width: 20, height: 20);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        image.setPixelRgba(x, y, 15, 120, 30, 255);
      }
    }

    final bytes = Uint8List.fromList(img.encodeJpg(image));
    expect(ImageClassifierService.looksGreenish(bytes), isTrue);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const OstreaApp());
    expect(find.text(AppStringsHelper.homeTitle), findsOneWidget);
  });

  testWidgets('module section image renders without a fallback image', (
    WidgetTester tester,
  ) async {
    final module = LearningModule(
      id: 'module6',
      title: 'Pag-alis ng Espongha',
      description: 'Paano alisin ang espongha sa ibabaw ng talaba?',
      contentSections: const ['Suriin ang mga talaba.'],
      imageAsset: null,
    );

    await tester.pumpWidget(
      MaterialApp(home: LearningModuleScreen(module: module)),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/modules/module6_section1.png',
      ),
      findsOneWidget,
    );
  });

  testWidgets('About Us shows the app developer team', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 5000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: AboutUsScreen()),
    );

    expect(find.text('Mga Developer ng App'), findsOneWidget);
    expect(find.text('Janelle A. Antipala'), findsOneWidget);
    expect(find.text('John Erol G. Tambal'), findsOneWidget);
    expect(find.text('Marilyn S. Bujos'), findsOneWidget);
  });
}
