import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ostrea/models/learning_module.dart';

class LocalDataService {
  static const String _learningModulesKey = 'learning_modules';
  static const String _troubleshootingGuidesKey = 'troubleshooting_guides';
  static const String _mapLocationsKey = 'map_locations';

  static final LocalDataService _instance = LocalDataService._internal();

  factory LocalDataService() => _instance;

  LocalDataService._internal();

  // Learning Modules Methods
  Future<List<LearningModule>> getLearningModules() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_learningModulesKey);
    
    if (jsonString == null) {
      // Initialize with default modules
      final modules = _getDefaultLearningModules();
      await _saveLearningModules(modules);
      return modules;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((item) => LearningModule(
        id: item['id'],
        title: item['title'],
        description: item['description'],
        contentSections: List<String>.from(item['content_sections']),
        imageAsset: item['image_asset'],
        videoAsset: item['video_asset'],
        hasVoiceNarration: item['has_voice_narration'] ?? true,
      )).toList();
    } catch (e) {
      return _getDefaultLearningModules();
    }
  }

  Future<void> _saveLearningModules(List<LearningModule> modules) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(modules.map((m) => {
      'id': m.id,
      'title': m.title,
      'description': m.description,
      'content_sections': m.contentSections,
      'image_asset': m.imageAsset,
      'video_asset': m.videoAsset,
      'has_voice_narration': m.hasVoiceNarration,
    }).toList());
    await prefs.setString(_learningModulesKey, json);
  }

  // Troubleshooting Guides Methods
  Future<List<TroubleshootingGuide>> getTroubleshootingGuides() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_troubleshootingGuidesKey);
    
    if (jsonString == null) {
      // Initialize with default guides
      final guides = _getDefaultTroubleshootingGuides();
      await _saveTroubleshootingGuides(guides);
      return guides;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((item) => TroubleshootingGuide(
        id: item['id'],
        title: item['title'],
        problem: item['problem'],
        cause: item['cause'],
        solutions: List<String>.from(item['solutions']),
        imageAsset: item['image_asset'],
        videoAsset: item['video_asset'],
        severity: item['severity'],
      )).toList();
    } catch (e) {
      return _getDefaultTroubleshootingGuides();
    }
  }

  Future<void> _saveTroubleshootingGuides(List<TroubleshootingGuide> guides) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(guides.map((g) => {
      'id': g.id,
      'title': g.title,
      'problem': g.problem,
      'cause': g.cause,
      'solutions': g.solutions,
      'image_asset': g.imageAsset,
      'video_asset': g.videoAsset,
      'severity': g.severity,
    }).toList());
    await prefs.setString(_troubleshootingGuidesKey, json);
  }

  // Map Locations Methods
  Future<List<Map<String, dynamic>>> getMapLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_mapLocationsKey);
    
    if (jsonString == null) {
      // Initialize with default location
      final locations = _getDefaultMapLocations();
      await _saveMapLocations(locations);
      return locations;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((item) => {
        'id': item['id'] as String,
        'name': item['name'] as String,
        'latitude': item['latitude'] as double,
        'longitude': item['longitude'] as double,
        'description': item['description'] as String?,
      }).toList();
    } catch (e) {
      return _getDefaultMapLocations();
    }
  }

  Future<void> _saveMapLocations(List<Map<String, dynamic>> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(locations);
    await prefs.setString(_mapLocationsKey, json);
  }

  // Default data
  List<LearningModule> _getDefaultLearningModules() {
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
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
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
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
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
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
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
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
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
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
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
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
      ),
    ];
  }

  List<TroubleshootingGuide> _getDefaultTroubleshootingGuides() {
    return [
      TroubleshootingGuide(
        id: 'disease1',
        title: 'Sakit ng Shell',
        problem: 'Oysters na may white spots o lesions sa shell',
        cause: 'Bacterial infection, mabuting water quality, o shell damage',
        solutions: [
          'Pahusayin ang water circulation at aeration',
          'Alisin ang affected oysters upang maiwasan ang kumalat',
          'Panatilihing pH 7.5-8.5',
          'Siguraduhin ang sapat na calcium para sa shell repair',
          'Subaybayan ang water temperature - ideally 15-25°C',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'algae1',
        title: 'Sobrang Algae Growth',
        problem: 'Green o brown algae blooms sa farming area',
        cause: 'Nutrient-rich water, mainit na temperatura, stagnant water',
        solutions: [
          'Taasan ang water exchange rate',
          'Bawasan ang nutrient input from feed',
          'Gumamit ng algae-eating species kung available',
          'Ani ng excess algae mechanically',
          'Subaybayan ang ammonia at nitrate levels',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        severity: 'medium',
      ),
      TroubleshootingGuide(
        id: 'mortality1',
        title: 'Mataas na Oyster Mortality',
        problem: 'Significant oyster death rate (>10% per month)',
        cause: 'Mabuting water quality, temperature extremes, sakit, o inadequate food',
        solutions: [
          'Suriin ang water quality parameters araw-araw',
          'I-adjust ang stocking density',
          'Siguraduhin ang sapat na phytoplankton food',
          'Tingnan ang parasites o diseases',
          'Panatilihing consistent ang temperature',
          'Pahusayin ang water filtration',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'growth1',
        title: 'Mabagal na Growth Rate',
        problem: 'Oysters na hindi lumalaki sa expected rate',
        cause: 'Inadequate food availability, mabuting water quality, temperature stress',
        solutions: [
          'Taasan ang water flow rate',
          'Magdagdag ng natural food sources (diatoms, flagellates)',
          'Gumamit ng supplemental feeds kung available',
          'Bawasan ang stocking density para sa better feeding',
          'Subaybayan ang temperature stability',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        severity: 'medium',
      ),
      TroubleshootingGuide(
        id: 'parasite1',
        title: 'Parasitic Infection',
        problem: 'Oysters na nagpapakita ng weakness, gaping, o poor meat quality',
        cause: 'Perkinsus, Bonamia, o other parasitic protozoa',
        solutions: [
          'I-implement ang quarantine para sa new stock',
          'Subaybayan ang spat at seed oysters para sa parasites',
          'Panatilihing optimal ang water conditions',
          'Alisin agad ang infected oysters',
          'I-disinfect ang tools at equipment between operations',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'spat1',
        title: 'Mabiting Spat Settlement',
        problem: 'Mababang settlement rate ng oyster larvae',
        cause: 'Inadequate settlement cues, mabuting substrate, wrong temperature',
        solutions: [
          'Gumamit ng conditioned shells bilang settlement substrate',
          'Panatilihing temperature 18-20°C during settlement',
          'Siguraduhin ang adequate bacterial biofilm sa substrate',
          'Panatilihing madilim ang settlement area initially',
          'Gumamit ng pheromone attractants kung available',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        severity: 'high',
      ),
    ];
  }

  List<Map<String, dynamic>> _getDefaultMapLocations() {
    return [
      {
        'id': 'farm1',
        'name': 'Sample Oyster Farm',
        'latitude': 14.346233,
        'longitude': 120.779424,
        'description': 'A sample oyster farm location',
      },
    ];
  }
}
