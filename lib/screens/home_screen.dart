import 'package:flutter/material.dart';
import 'package:ostrea/screens/oyster_farm_map_screen.dart';
import 'package:ostrea/screens/learning_modules_screen.dart';
import 'package:ostrea/screens/troubleshooting_screen.dart';
import 'package:ostrea/screens/species_identification_screen.dart';
import 'package:ostrea/screens/settings_screen.dart';
import 'package:ostrea/localization/app_strings_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  late List<String> _titles;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    _screens = [
      const OysterFarmMapScreen(),
      LearningModulesScreen(),
      TroubleshootingScreen(),
      SpeciesIdentificationScreen(),
      SettingsScreen(onLanguageChanged: _refreshScreens),
    ];

    _titles = [
      'Oyster Farm Map',
      AppStringsHelper.titleLearningModules,
      AppStringsHelper.titleTroubleshooting,
      AppStringsHelper.titleSpeciesID,
      AppStringsHelper.titleSettings,
    ];
  }

  void _refreshScreens() {
    setState(() {
      _initializeScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: AppStringsHelper.navLearn,
          ),
          NavigationDestination(
            icon: Icon(Icons.build),
            label: AppStringsHelper.navTroubleshoot,
          ),
          NavigationDestination(
            icon: Icon(Icons.image),
            label: AppStringsHelper.navIdentify,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: AppStringsHelper.navSettings,
          ),
        ],
      ),
    );
  }
}
