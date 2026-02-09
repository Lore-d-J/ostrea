import 'package:flutter/material.dart';
import 'package:ostrea/models/learning_module.dart';
import 'package:ostrea/screens/learning_module_screen.dart';
import 'package:ostrea/services/local_storage_service.dart';
import 'package:ostrea/localization/app_strings.dart';

class LearningModulesScreen extends StatefulWidget {
  const LearningModulesScreen({super.key});

  @override
  State<LearningModulesScreen> createState() => _LearningModulesScreenState();
}

class _LearningModulesScreenState extends State<LearningModulesScreen> {
  late List<LearningModule> modules;
  List<String> _completedModules = [];
  List<String> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    modules = _getModules();
    _loadProgress();
  }

  void _loadProgress() async {
    final completed = await LocalStorageService.getCompletedModules();
    final bookmarks = await LocalStorageService.getBookmarks();
    setState(() {
      _completedModules = completed;
      _bookmarks = bookmarks;
    });
  }

  List<LearningModule> _getModules() {
    return [
      LearningModule(
        id: 'module1',
        title: 'Introduction to Oyster Farming',
        description: 'Learn the basics of oyster farming and cultivation',
        contentSections: [
          'Oyster farming is one of the most sustainable forms of aquaculture. Oysters are filter-feeders that improve water quality while providing a nutritious food source. They require minimal feed or chemical inputs and can help restore degraded marine ecosystems.',
          'There are three main oyster farming systems: pond systems, bag systems, and cage systems. Each has advantages depending on your location, climate, and available resources. Pond systems are excellent for beginners as they require less equipment.',
          'The oyster farming lifecycle includes: breeding selection, larval production, spat collection, juvenile rearing, and adult grow-out. The entire cycle from spat to market-sized oyster typically takes 2-3 years depending on species and conditions.',
          'Successful oyster farming requires careful attention to water quality, temperature, salinity, and nutrient levels. Daily monitoring of these parameters helps prevent disease and ensures optimal growth rates.',
        ],
      ),
      LearningModule(
        id: 'module2',
        title: 'Water Quality Management',
        description: 'Essential parameters for healthy oyster farming',
        contentSections: [
          'Water quality is the foundation of successful oyster farming. The four most critical parameters are pH, dissolved oxygen, salinity, and temperature. Each must be maintained within specific ranges for oyster health.',
          'pH should be maintained between 7.5 and 8.5. This range supports oyster shell formation and maintains healthy bacterial communities. Test pH daily with a calibrated meter.',
          'Dissolved oxygen (DO) must stay above 5 mg/L for oyster survival. Improve aeration by increasing water flow, using paddle wheels, or installing air stones. Low DO levels lead to stress and disease.',
          'Salinity varies by oyster species. Eastern oysters prefer 10-30 ppt, while Pacific oysters do well at 20-35 ppt. Mangrove oysters tolerate lower salinities. Monitor with a refractometer or conductivity meter.',
          'Temperature affects growth rate and disease susceptibility. Optimal range is 15-25°C for most species. Temperatures above 25°C increase stress and disease risk. Prevent rapid temperature changes which can shock oysters.',
        ],
      ),
      LearningModule(
        id: 'module3',
        title: 'Nutrition and Feeding',
        description: 'Understanding oyster dietary needs',
        contentSections: [
          'Oysters are filter feeders that primarily consume phytoplankton and zooplankton. In natural systems, they obtain nutrition from the water column without additional feeding.',
          'Diatoms and flagellates (single-celled algae) are the preferred food organisms. These naturally occur in healthy waters and provide the nutrients oysters need for shell and tissue growth.',
          'Water flow is critical for feeding. Oysters need adequate current to deliver food particles. A minimum flow rate of 2-3 times the tank or pond volume per hour is recommended.',
          'In closed systems, you may need to supplement nutrition with phytoplankton culture or commercial oyster feeds. However, maintain natural food sources as much as possible for better health.',
          'Poor feeding is indicated by slow growth, thin shells, and low body condition. If this occurs, increase water exchange, improve aeration, and consider adding commercial feeds.',
        ],
      ),
      LearningModule(
        id: 'module4',
        title: 'Disease Prevention and Management',
        description: 'Identifying and preventing common oyster diseases',
        contentSections: [
          'Oyster diseases fall into three categories: bacterial infections, parasitic infestations, and viral diseases. Prevention through good husbandry is far more effective than treatment.',
          'The most effective disease prevention strategy is maintaining optimal water conditions. Stressed oysters with poor water quality are susceptible to all diseases.',
          'Quarantine new stock before introduction. Test for common parasites like Perkinsus and Bonamia. Never mix stock from different sources without proper disease screening.',
          'Shell disease appears as brown spots or erosion. Caused by bacteria, it\'s prevented by maintaining low ammonia, adequate oxygen, and stable pH.',
          'Good sanitation practices include disinfecting tools, equipment, and containers between uses. Use 10% bleach solution or 70% ethanol. Proper disposal of dead oysters prevents disease spread.',
        ],
      ),
      LearningModule(
        id: 'module5',
        title: 'Spat Collection and Seed Production',
        description: 'Techniques for collecting and rearing oyster spat',
        contentSections: [
          'Spat are newly settled oyster larvae, typically collected in spring and summer. Natural spat fall can be encouraged by providing settlement substrate and maintaining ideal conditions.',
          'Settlement substrate includes oyster shells, PVC pipes, and specialized collectors. Condition substrate by exposing it to healthy biofilm and larval-rich water before collection season.',
          'Larvae settle best in warm, well-mixed water with good food availability. Maintain temperature around 18-20°C and ensure adequate aeration during settlement.',
          'Hatchery-produced spat offers advantages including disease control and consistent supply. Hatcheries artificially trigger spawning through temperature manipulation and provide controlled rearing conditions.',
          'Once settled, spat must be protected from predators and monitored carefully. Move from collectors to nursery systems after 2-3 weeks of settlement to maximize survival rates.',
        ],
      ),
      LearningModule(
        id: 'module6',
        title: 'Growth Optimization and Harvesting',
        description: 'Maximizing growth rates and proper harvesting techniques',
        contentSections: [
          'Growth rates depend on water quality, food availability, temperature, and stocking density. Eastern oysters grow approximately 2-3 cm per year under good conditions.',
          'Stocking density affects individual growth. Higher density reduces food availability per oyster. Optimal density varies by system but generally 100-300 oysters per square meter.',
          'Market size varies by region and end use. Typically oysters reach market size (75-100mm) in 2-3 years. Some markets prefer smaller oysters while others demand larger ones.',
          'Harvest by carefully removing oysters from collectors or culture systems. Handle gently to avoid shell damage. Purge in clean water for 24-48 hours before sale to remove sediment.',
          'Post-harvest handling is critical. Keep oysters cool and moist, never submerged in fresh water. Maintain temperature around 10-15°C and ship in well-ventilated containers.',
        ],
      ),
    ];
  }

  void _navigateToModule(LearningModule module) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningModuleScreen(module: module),
      ),
    ).then((_) {
      _loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          final isCompleted = _completedModules.contains(module.id);
          final isBookmarked = _bookmarks.contains(module.id);

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _navigateToModule(module),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                module.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isCompleted)
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${module.contentSections.length} sections',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            if (isBookmarked) {
                              LocalStorageService.removeBookmark(module.id);
                            } else {
                              LocalStorageService.addBookmark(module.id);
                            }
                            _loadProgress();
                          },
                          constraints:
                              BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
