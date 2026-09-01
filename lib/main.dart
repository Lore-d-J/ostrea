import 'package:flutter/material.dart';
import 'package:ostrea/theme/app_theme.dart';
import 'package:ostrea/screens/animated_splash_screen.dart';
import 'package:ostrea/localization/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OstreaApp());
}

class OstreaApp extends StatelessWidget {
  const OstreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSTREA - ${AppStrings.homeSubtitle}',
      theme: AppTheme.getTheme(),
      home: const AnimatedSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
