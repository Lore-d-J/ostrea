import 'package:flutter/material.dart';
import 'package:ostrea/screens/learning_modules_screen.dart';
import 'package:ostrea/screens/troubleshooting_screen.dart';
import 'package:ostrea/screens/disease_identification_screen.dart';
import 'package:ostrea/localization/app_strings_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens = [
      LearningModulesScreen(),
      TroubleshootingScreen(),
      DiseaseIdentificationScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.school, color: _selectedIndex == 0 ? Theme.of(context).colorScheme.primary : Colors.grey),
              label: AppStringsHelper.navLearn,
            ),
            NavigationDestination(
              icon: Icon(Icons.build, color: _selectedIndex == 1 ? Theme.of(context).colorScheme.primary : Colors.grey),
              label: AppStringsHelper.navTroubleshoot,
            ),
            NavigationDestination(
              icon: Icon(Icons.image, color: _selectedIndex == 2 ? Theme.of(context).colorScheme.primary : Colors.grey),
              label: AppStringsHelper.navIdentify,
            ),
          ],
        ),
      ),
    );
  }
}
