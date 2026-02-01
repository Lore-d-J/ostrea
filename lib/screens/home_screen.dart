import 'package:flutter/material.dart';
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
      _HomeContent(),
      LearningModulesScreen(),
      TroubleshootingScreen(),
      SpeciesIdentificationScreen(),
      SettingsScreen(onLanguageChanged: _refreshScreens),
    ];

    _titles = [
      AppStringsHelper.titleOysterFarming,
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
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0,
      ),
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
            icon: Icon(Icons.home),
            label: AppStringsHelper.navHome,
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

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header banner
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStringsHelper.homeTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppStringsHelper.homeSubtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Quick access cards
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStringsHelper.quickLinksTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _QuickAccessCard(
                      title: AppStringsHelper.titleLearningModules,
                      description: 'Matuto ng oyster farming',
                      icon: Icons.school,
                      color: Colors.blue,
                      onTap: () {
                        // Navigation handled by parent
                      },
                    ),
                    _QuickAccessCard(
                      title: AppStringsHelper.titleTroubleshooting,
                      description: 'Solusyunan ang mga isyu',
                      icon: Icons.build,
                      color: Colors.orange,
                      onTap: () {
                        // Navigation handled by parent
                      },
                    ),
                    _QuickAccessCard(
                      title: AppStringsHelper.titleSpeciesID,
                      description: 'Kilalanin ang uri ng oyster',
                      icon: Icons.image,
                      color: Colors.green,
                      onTap: () {
                        // Navigation handled by parent
                      },
                    ),
                    _QuickAccessCard(
                      title: 'Kalidad ng Tubig',
                      description: 'Subaybayan ang mga parameter',
                      icon: Icons.water_drop,
                      color: Colors.cyan,
                      onTap: () {
                        // Navigation handled by parent
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  'Mahalagang Impormasyon',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 12),
                _InfoCard(
                  title: 'Optimal na Kondisyon',
                  items: [
                    'Temperatura: 15-25°C',
                    'pH: 7.5-8.5',
                    'Salinity: 10-35 ppt (depende sa spesye)',
                    'Dissolved Oxygen: >5 mg/L',
                  ],
                ),
                SizedBox(height: 12),
                _InfoCard(
                  title: 'Siklo ng Pagpapalaki',
                  items: [
                    'Pagkolekta ng Spat: Tagsibol/Tag-init',
                    'Nursery phase: 2-3 buwan',
                    'Grow-out phase: 18-24 buwan',
                    'Ani: Market-sized oysters',
                  ],
                ),
                SizedBox(height: 12),
                _InfoCard(
                  title: 'Pagpapahintulot ng Sakit',
                  items: [
                    'Panatilihing mataas ang kalidad ng tubig',
                    'Bantayan ang kalusugan ng oyster araw-araw',
                    'Ihiwalay ang bagong stock',
                    'Gamitin ang tamang kalinisan',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const _InfoCard({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
