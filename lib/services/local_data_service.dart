import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ostrea/models/learning_module.dart';

class LocalDataService {
  static const String _learningModulesKey = 'learning_modules';
  static const String _troubleshootingGuidesKey = 'troubleshooting_guides';
  static const String _mapLocationsKey = 'map_locations';
  static const String _dictionaryKey = 'dictionary_entries';

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

  // Dictionary Methods
  Future<List<DictionaryEntry>> getDictionaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_dictionaryKey);
    
    if (jsonString == null) {
      // Initialize with default entries
      final entries = _getDefaultDictionaryEntries();
      await _saveDictionaryEntries(entries);
      return entries;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((item) => DictionaryEntry(
        term: item['term'],
        definition: item['definition'],
        category: item['category'],
        relatedTerms: List<String>.from(item['related_terms']),
      )).toList();
    } catch (e) {
      return _getDefaultDictionaryEntries();
    }
  }

  Future<void> _saveDictionaryEntries(List<DictionaryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(entries.map((e) => {
      'term': e.term,
      'definition': e.definition,
      'category': e.category,
      'related_terms': e.relatedTerms,
    }).toList());
    await prefs.setString(_dictionaryKey, json);
  }

  // Default data
  List<LearningModule> _getDefaultLearningModules() {
    return [
      LearningModule(
        id: 'module1',
        title: 'Panimula sa Pag-aalaga ng Talaba',
        description: 'Alamin ang mga pangunahing kaalaman sa pag-aalaga at paglaki ng talaba',
        contentSections: [
          'Ang pag-aalaga ng talaba ay ang paglilinang ng mga talaba sa mga lugar na may tubig na tabang at katubigan para sa pagkain at kabuhayan. Ito ay isang murang gawain sa aquaculture dahil ang mga talaba ay natural na kumakain ng plankton na matatagpuan sa tubig. Ang pag-aalaga ng talaba ay nagbibigay ng oportunidad sa kita para sa mga komunidad sa baybayin at nag-aambag sa lokal na produksyon ng pagkain.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module2',
        title: 'Kahalagahan ng Pag-aalaga ng Talaba',
        description: 'Unawain ang kahalagahan ng pag-aalaga ng talaba para sa mga komunidad at kapaligiran',
        contentSections: [
          'Ang pag-aalaga ng talaba ay sumusuporta sa seguridad sa pagkain at sa ekonomikal na pag-unlad sa mga komunidad sa baybayin. Ito ay nagbibigay ng sustainable na mapagkukunan ng karne ng dagat habang hindi nangangailangan ng maraming artificial na pagpapakain. Ang mga farm ng talaba ay maaari ding pagbutihin ang kalidad ng tubig dahil ang mga talaba ay nagfi-filter ng mga particle mula sa tubig.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module3',
        title: 'Mga Uri ng Talaba sa Pilipinas',
        description: 'Alamin ang mga uri ng talaba na lumalago sa mainit na tubig ng Pilipinas',
        contentSections: [
          'Maraming uri ng talaba ang lumalago sa mainit at tropikal na tubig. Ang mga talabang ito ay kumakapit sa mga hard na ibabaw at lumalaki sa mga cluster. Ang pag-unawa sa mga lokal na uri ay tumutulong sa mga magsasaka na pagtakpan ang rate ng paglaki at angkop na kondisyon ng pag-aalaga.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module4',
        title: 'Anatomi ng Talaba',
        description: 'Galugarin ang panloob na istruktura at mga organ ng talaba',
        contentSections: [
          'Ang mga talaba ay may hard na shell na nagpoprotekta sa kanilang malambot na katawan. Sa loob ng shell ay may mahalagang mga organ na responsable sa pagkain, paghinga, at reproduksyon. Ang kanilang mga gill ay nagfi-filter ng plankton at iba pang microscopic na pagkain mula sa tubig.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module5',
        title: 'Siklo ng Buhay ng Talaba',
        description: 'Unawain ang mga developmental na yugto ng talaba',
        contentSections: [
          'Ang mga talaba ay dumadaan sa ilang developmental na yugto:',
          'Itlog',
          'Larva',
          'Spat',
          'Juvenile',
          'Adult',
          'Ang yugtong spat ang mahalagang dahil ito ang panahon kung kailan ang mga talaba ay kumakapit sa mga ibabaw na ginagamit sa pag-aalaga.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module6',
        title: 'Pagpili ng Lugar para sa Pag-aalaga ng Talaba',
        description: 'Alamin kung paano pumili ng tamang lugar para sa mga farm ng talaba',
        contentSections: [
          'Ang pagpili ng angkop na lugar ay mahalagang para sa matagumpay na pag-aalaga ng talaba.',
          'Mahalagang mga salik:',
          'Malinis na tubig',
          'Magandang sirkulasyon ng tubig',
          'Katamtamang asin',
          'Proteksyon mula sa malalakas na alon',
          'Availability ng plankton',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module7',
        title: 'Mga Materyales na Ginagamit sa Pag-aalaga ng Talaba',
        description: 'Tuklasin ang mga tool at materyales na kailangan para sa kultura ng talaba',
        contentSections: [
          'Ang kultura ng talaba ay nangangailangan ng simple at abot-kayang materyales tulad ng:',
          'Mga poste ng kawayan',
          'Mga nylon na lubid',
          'Mga shell ng talaba',
          'Mga net o basket',
          'Mga float',
          'Ang mga materyales na ito ay ginagamit upang bumuo ng mga istruktura kung saan maaaring kumapit at lumaki ang mga talaba.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module8',
        title: 'Mga Paraan ng Pag-aalaga ng Talaba',
        description: 'Galugarin ang iba\'t ibang teknik para sa paglaki ng talaba',
        contentSections: [
          'Ang mga karaniwang paraan ng pag-aalaga ng talaba ay kinabibilangan ng:',
          'Stake Method – Ang mga poste ng kawayan ay itinanim sa mababaw na tubig kung saan kumakapit ang spat ng talaba.',
          'Hanging Method – Ang mga shell ay itinali sa mga lubid na nakasabit sa tubig.',
          'Tray o Basket Method – Ang mga talaba ay lumalaki sa mga container na nakasabit sa tubig.',
          'Ang bawat paraan ay may mga benepisyo depende sa mga kondisyon ng farm.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module9',
        title: 'Pagkolekta ng Spat',
        description: 'Alamin kung paano mangolekta ng mga batang talaba mula sa natural na tubig',
        contentSections: [
          'Ang koleksyon ng spat ay ang proseso ng pagkuha ng mga batang talaba mula sa natural na tubig. Ang mga magsasaka ay naglalagay ng mga collector tulad ng shell o kawayan sa tubig upang akitin ang mga larva ng talaba. Kapag ang spat ay kumakapit sa mga collector na ito, maaari silang ilipat sa mga kulturang istruktura.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module10',
        title: 'Pagpapanatili ng Farm',
        description: 'Unawain ang kahalagahan ng regular na pag-aalaga ng farm',
        contentSections: [
          'Ang regular na pagpapanatili ng farm ay tinitiyak ang malusog na paglaki ng talaba.',
          'Mga aktibidad ay kinabibilangan ng:',
          'Pagsusuri sa mga istrukturang kawayan',
          'Paglilinis ng mga lubid at collector',
          'Pag-alis ng mga mandaragit',
          'Pagsusuri sa paglaki ng talaba',
          'Ang wastong pagpapanatili ay pumipigil sa pinsala sa farm at nagpapabuti ng produksyon.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module11',
        title: 'Pamamahala ng Kalidad ng Tubig',
        description: 'Alamin kung paano panatilihin ang optimal na kondisyon ng tubig',
        contentSections: [
          'Ang kalidad ng tubig ay nakakaapekto sa kaligtasan at paglaki ng talaba.',
          'Mahalagang mga salik:',
          'Asin',
          'Temperatura',
          'Dissolved oxygen',
          'Malinis na tubig',
          'Ang maruming tubig ay maaaring makasama sa mga talaba at gawing hindi ligtas ang mga ito para sa pagkain.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module12',
        title: 'Mga Mandaragit at Pesteng Hayop',
        description: 'Kilalanin at pamahalaan ang mga banta sa mga farm ng talaba',
        contentSections: [
          'May ilang organismo na maaaring makasama sa mga farm ng talaba.',
          'Mga halimbawa:',
          'Mga alimango',
          'Mga bituin ng dagat',
          'Mga suso',
          'Mga mandaragit na drilling',
          'Ang mga magsasaka ay dapat regular na suriin ang mga farm at alisin ang mga pesteng ito.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module13',
        title: 'Paglaki at Pagsubaybay ng Talaba',
        description: 'Alamin kung paano subaybayan ang pag-unlad ng talaba',
        contentSections: [
          'Ang mga magsasaka ay dapat subaybayan ang paglaki ng talaba nang regular. Kasama rito ang pagsusuri sa laki ng shell, timbang, at general na kalusugan. Ang pagsubaybay ay tumutulong na pagtakpan ang tamang oras para sa pag-aani.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module14',
        title: 'Paghahakot ng Talaba',
        description: 'Unawain ang wastong mga teknik ng pag-aani',
        contentSections: [
          'Ang mga talaba ay karaniwang inaani kapag umaabot sila sa laking maaaring ibenta. Ang mga magsasaka ay nag-aalis ng mga mature na talaba mula sa mga lubid o collector. Ang mga maliit na talaba ay maaaring ibalik sa farm para sa karagdagang paglaki.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module15',
        title: 'Kaligtasan sa Kapaligiran at Kalusugan',
        description: 'Alamin ang mga konsiderasyon sa kaligtasan sa pag-aalaga ng talaba',
        contentSections: [
          'Ang kaligtasan sa kapaligiran ay mahalagang sa pag-aalaga ng talaba.',
          'Ang mga magsasaka ay dapat iwasan ang pag-aani sa panahon ng:',
          'Mga kaganapan ng polusyon sa tubig',
          'Mga mapaminsalang algal bloom',
          'Mga outbreak ng red tide',
          'Ito ay tinitiyak ang kaligtasan ng mga consumer.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module16',
        title: 'Oyster Farming Module',
        description: 'Comprehensive guide to oyster classification, habitat, farming, and conservation',
        contentSections: [
          'MODULE: OYSTER\nLesson 1: Classification of Oysters\nOverview / Introduction :\nOysters are marine animals known as bivalve mollusks, meaning they have two hard shells that protect their soft bodies. They are invertebrates, which means they do not have a backbone. Oysters belong to the phylum Mollusca, which also includes clams, mussels, and snails. There are many species of oysters around the world; some are cultivated for food, while others are famous for producing pearls. Studying the classification of oysters helps us understand their behavior, habitat, and how to farm them sustainably.\nLearning Objectives:\nExplain what oysters are and how they are classified.\nDescribe the characteristics of bivalve mollusks.\nUnderstand the difference between edible oysters and pearl-producing oysters.\nRecognize the importance of classification in studying oysters.\nExplanation:\nOysters are classified as marine invertebrates because they do not have a backbone. They belong to the class Bivalvia, which refers to animals with two shells connected by a hinge. This shell protects the soft body inside and helps the oyster survive in its environment. Some oysters are farmed for food because they grow fast and are nutritious. Others are known for their ability to produce pearls, which have economic value in jewelry. Scientists study oyster classification to learn how different species adapt to water conditions, reproduce, and interact with other marine animals.\nKey Points:\nOysters are bivalve invertebrates with two shells.\nShells protect their soft bodies from predators.\nSome species are for food, others for pearls.\nClassification helps understand oyster biology and farming.',
          'Lesson 2: Physical Structure of Oysters\nOverview:\nThis lesson describes the parts of an oyster\'s body and explains how each part helps the oyster survive in the ocean.\nLearning Objectives:\nIdentify the main body parts of an oyster.\nExplain the function of the shell, mantle, gills, and adductor muscle.\nUnderstand how oysters feed, breathe, and protect themselves.\nExplanation:\nThe oyster\'s most visible feature is its shell, made of two valves connected by a hinge. This hinge allows the oyster to open and close the shell. Inside, the mantle covers the body and produces the shell material, allowing the oyster to grow larger. Oysters breathe and feed through their gills, which capture oxygen and tiny food particles like plankton from the water. The adductor muscle is very strong and closes the shell tightly to protect the oyster from predators, such as crabs and starfish. Every part of the oyster\'s body has a purpose, whether it\'s for protection, feeding, or growth.\nKey Points:\nShells open and close to feed and protect the oyster.\nMantle produces shell and allows growth.\nGills filter food and oxygen from water.\nAdductor muscle protects the oyster from predators.',
          'Lesson 3: Habitat of Oysters\nOverview:\nOysters are usually found in coastal waters where saltwater and freshwater meet, called estuaries. These areas are rich in nutrients, making them perfect for oysters.\nLearning Objectives:\nDescribe the natural habitats of oysters.\nExplain why estuaries are ideal for oyster growth.\nUnderstand the formation and importance of oyster reefs.\nExplanation:\nOysters attach to hard surfaces like rocks, shells, or man-made structures and usually stay in one place for most of their lives, making them sessile animals. When many oysters grow together, they form oyster reefs, which serve as homes for many marine animals, including fish, crabs, and shrimp. These reefs also help protect the coast by reducing the impact of waves and preventing erosion. Healthy habitats are essential for oyster survival and for maintaining the balance of marine ecosystems.\nKey Points:\nOysters live in nutrient-rich estuaries.\nThey attach to surfaces and stay in one place.\nOyster reefs provide habitats for other marine animals.\nReefs protect shorelines from erosion.',
          'Lesson 4: Feeding Behavior\nOverview:\nOysters are filter feeders, which means they feed by filtering water to extract food. This behavior also improves water quality.\nLearning Objectives:\nExplain how oysters feed using gills and cilia.\nUnderstand the environmental benefits of oyster feeding.\nRecognize how feeding supports oyster survival.\nExplanation:\nWater enters the oyster\'s shell and passes over the gills, which trap tiny organisms like plankton and algae. Small hair-like structures called cilia move these food particles to the oyster\'s mouth. This feeding process allows oysters to survive without hunting actively. By filtering large amounts of water daily, oysters help remove excess nutrients and particles, keeping water cleaner. Scientists estimate that a single oyster can filter many liters of water each day, making oysters natural "water cleaners" of the ocean.\nKey Points:\nOysters feed by filtering water using gills and cilia.\nFeeding improves water quality and removes excess nutrients.\nOysters are natural water cleaners in their habitats.',
          'Lesson 5: Life Cycle of Oysters\nOverview:\nThis lesson explains how oysters reproduce, grow, and develop into adult oysters.\nLearning Objectives:\nDescribe oyster reproduction and spawning.\nIdentify the stages of oyster growth: larvae, spat, juvenile, adult.\nUnderstand how environmental factors influence growth.\nExplanation:\nAdult oysters release eggs and sperm into the water during spawning. Fertilized eggs become larvae, which float freely for several days or weeks. The larvae eventually attach to hard surfaces and become spat. Spat gradually grow shells, develop into juveniles, and eventually mature into adult oysters capable of reproducing. Growth and survival depend on factors like water quality, temperature, and food availability. Knowing the life cycle helps farmers and scientists manage oyster populations and support sustainable harvesting.\nKey Points:\nReproduction starts with spawning.\nGrowth stages: larvae → spat → juvenile → adult.\nWater quality, temperature, and food affect survival.',
          'Lesson 6: Importance of Oysters\nOverview:\nOysters are essential to marine ecosystems and human communities. They filter water, provide habitats, and protect shorelines.\nLearning Objectives:\nExplain how oysters maintain ecosystem health.\nDescribe the role of oyster reefs in supporting marine life.\nUnderstand how oyster reefs protect coastlines.\nExplanation:\nOysters remove excess nutrients, sediments, and algae from the water, improving water quality. Oyster reefs serve as homes for fish, crabs, and other animals, increasing biodiversity. Reefs also act as barriers that reduce wave impact, protecting shorelines from erosion. This shows that oysters are not just food—they play an active role in keeping marine ecosystems healthy.\nKey Points:\nOysters filter water to improve quality.\nReefs support marine biodiversity.\nOyster reefs protect coastlines from erosion.',
          'Lesson 7: Oyster Farming\nOverview:\nOyster farming, also called oyster aquaculture, is raising oysters in controlled environments for food and income.\nLearning Objectives:\nUnderstand how oyster farming is done.\nIdentify structures like cages, trays, and ropes.\nRecognize the benefits of oyster farming for communities.\nExplanation:\nFarmers collect young oysters called spat and place them in trays, cages, or ropes in coastal waters. Oysters naturally filter plankton, so they do not need artificial feed. This method is environmentally friendly and sustainable. Oyster farming provides income to coastal families and supports local markets and restaurants, creating jobs in farming, harvesting, and distribution.\nKey Points:\nOyster farming uses cages, trays, and ropes.\nOysters feed naturally by filtering water.\nFarming supports livelihoods and local economies.',
          'Lesson 8: Nutritional Value of Oysters\nOverview:\nOysters are highly nutritious and provide many benefits for human health.\nLearning Objectives:\nIdentify the nutrients in oysters.\nExplain the health benefits of eating oysters.\nUnderstand safe handling and consumption.\nExplanation:\nOysters are rich in protein, zinc, iron, and vitamin B12. Protein helps build and repair body tissues. Zinc supports the immune system, iron helps carry oxygen in the blood, and vitamin B12 is important for energy and nervous system function. Proper handling and cooking prevent illness from contaminated oysters, ensuring they are safe to eat.\nKey Points:\nRich in protein, zinc, iron, and vitamin B12.\nSupports growth, immunity, and energy.\nProper handling ensures food safety.',
          'Lesson 9: Threats to Oyster Populations\nOverview:\nOysters face threats from human activities, climate change, and natural hazards.\nLearning Objectives:\nIdentify threats like pollution and habitat loss.\nUnderstand climate change effects on oysters.\nRecognize dangers such as red tide.\nExplanation:\nWater pollution from chemicals, plastics, and waste harms oysters. Coastal development and dredging destroy habitats. Climate change affects water temperature and acidity, impacting shell growth. Red tide, caused by harmful algae, can kill oysters and pose health risks to humans. Protecting oysters requires awareness of these threats and responsible environmental practices.\nKey Points:\nPollution and habitat loss reduce oyster survival.\nClimate change affects growth and reproduction.\nRed tide is a natural hazard to oysters.',
          'Lesson 10: Conservation and Protection\nOverview:\nConservation ensures oysters remain abundant for ecosystems and human communities.\nLearning Objectives:\nLearn strategies to protect oysters.\nUnderstand reef restoration methods.\nRecognize sustainable oyster farming practices.\nExplanation:\nConservation efforts include restoring reefs, placing empty shells for larvae attachment, and using sustainable farming. These practices maintain oyster populations, support livelihoods, and protect ecosystems. By caring for oysters today, communities ensure that future generations will continue to benefit from their environmental and economic contributions.\nKey Points:\nReef restoration supports oyster populations.\nSustainable farming balances use and conservation.\nHealthy oysters benefit both nature and communities.',
          'SUMMARY\nOysters, or talaba, are marine shellfish that live in coastal waters, especially in estuaries where freshwater and seawater mix. They belong to bivalve mollusks, meaning they have two hard shells that protect their soft bodies. Oysters attach themselves to hard surfaces and usually stay in one place as they grow. They are filter feeders, meaning they get food by filtering plankton and small particles from water. Because of this, oysters help clean the water and keep marine ecosystems healthy. Their life cycle starts from eggs and larvae, then becomes spat, juvenile, and finally adult oysters. Oyster farming is an important source of food and livelihood, especially in coastal communities. Farmers grow oysters using methods like stake, hanging, and long line systems. Proper site selection, maintenance, and care are important to ensure healthy oyster growth. Oysters are harvested when they reach the right size and are handled carefully to keep their quality. Oysters are also valuable to the environment and economy. They provide food, jobs, and income, while also helping protect shorelines and providing habitats for marine animals. However, they face threats such as pollution, climate change, habitat destruction, and red tide. Because of these threats, conservation is important. Sustainable farming, clean water practices, and reef restoration help protect oyster populations. In the end, oysters are important not only as food but also for maintaining healthy ecosystems and supporting communities.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
    ];
  }

  List<TroubleshootingGuide> _getDefaultTroubleshootingGuides() {
    return [
      TroubleshootingGuide(
        id: 'trouble1',
        title: 'Mabagal na Paglaki ng Talaba',
        problem: 'Ang mga talaba ay lumalaki nang mas mabagal kaysa sa inaasahan',
        cause: 'Mabuting kalidad ng tubig',
        solutions: [
          'Ilipat ang farm sa mas magandang lugar',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'medium',
      ),
      TroubleshootingGuide(
        id: 'trouble2',
        title: 'Kamatayan ng Talaba',
        problem: 'Ang mga talaba ay namamatay',
        cause: 'Mababang oxygen o polusyon',
        solutions: [
          'Suriin ang kondisyon ng tubig',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'trouble3',
        title: 'Walang Settlement ng Spat',
        problem: 'Walang mga batang talaba na kumakapit sa mga collector',
        cause: 'Maling season o lugar',
        solutions: [
          'Maglagay ng mas maraming collector',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'medium',
      ),
      TroubleshootingGuide(
        id: 'trouble4',
        title: 'Sira na mga Istrukturang Farm',
        problem: 'Ang mga istrukturang farm ay sira',
        cause: 'Malalakas na alon o bagyo',
        solutions: [
          'Palakasin ang mga poste ng kawayan',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'trouble5',
        title: 'Shell na Takip ng Putik',
        problem: 'Ang mga shell ng talaba ay takip ng putik',
        cause: 'Mataas na sedimentasyon',
        solutions: [
          'Linisin ang mga collector nang regular',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'low',
      ),
      TroubleshootingGuide(
        id: 'trouble6',
        title: 'Atake ng mga Mandaragit',
        problem: 'Ang mga talaba ay kinakain ng mga mandaragit',
        cause: 'Mga alimango o suso',
        solutions: [
          'Alisin ang mga mandaragit nang manual',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'trouble7',
        title: 'Maliit na Sukat ng Talaba',
        problem: 'Ang mga talaba ay masyadong maliit',
        cause: 'Overcrowding',
        solutions: [
          'Bawasan ang bilang ng mga talaba',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'medium',
      ),
      TroubleshootingGuide(
        id: 'trouble8',
        title: 'Talaba na Nahuhulog sa mga Lubid',
        problem: 'Ang mga talaba ay nahuhulog mula sa mga kulturang istruktura',
        cause: 'Mahinang attachment',
        solutions: [
          'Palitan ang mga collector',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        severity: 'medium',
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

  List<DictionaryEntry> _getDefaultDictionaryEntries() {
    return [
      DictionaryEntry(
        term: 'Aquaculture',
        definition: 'Ang paglilinang ng mga organismo sa tubig tulad ng isda, talaba, at algae para sa pagkain at iba pang produkto. Ito ay isang sustainable na paraan ng paglilinang na tumutulong sa pagkain ng mundo.',
        category: 'farming',
        relatedTerms: ['Pag-aalaga ng Talaba', 'Sustainable Farming'],
      ),
      DictionaryEntry(
        term: 'Plankton',
        definition: 'Mga maliliit na organismo na lumulutang sa tubig na siyang pangunahing pagkain ng mga talaba. Kabilang dito ang phytoplankton (mga halaman) at zooplankton (mga hayop).',
        category: 'biology',
        relatedTerms: ['Filter Feeders', 'Pagkain ng Talaba'],
      ),
      DictionaryEntry(
        term: 'Spat',
        definition: 'Ang yugto ng talaba kung saan ang mga larva ay kumakapit na sa isang ibabaw at nagsisimulang bumuo ng shell. Ito ang simula ng paglaki ng talaba sa farm.',
        category: 'biology',
        relatedTerms: ['Larva', 'Settlement', 'Juvenile'],
      ),
      DictionaryEntry(
        term: 'Larva',
        definition: 'Ang unang yugto ng buhay ng talaba pagkatapos ng itlog. Ang mga larva ay lumulutang sa tubig at naghahanap ng lugar upang kumakapit.',
        category: 'biology',
        relatedTerms: ['Spat', 'Life Cycle', 'Reproduction'],
      ),
      DictionaryEntry(
        term: 'Juvenile',
        definition: 'Ang yugto ng paglaki ng talaba pagkatapos ng spat. Sa yugtong ito, ang talaba ay lumalaki ngunit hindi pa handa para sa pag-aani.',
        category: 'biology',
        relatedTerms: ['Spat', 'Adult', 'Paglaki'],
      ),
      DictionaryEntry(
        term: 'Gill',
        definition: 'Ang organ ng talaba na ginagamit para sa paghinga at pagkain. Ito ay nagfi-filter ng oxygen at plankton mula sa tubig.',
        category: 'biology',
        relatedTerms: ['Filter Feeders', 'Respiration', 'Cilia'],
      ),
      DictionaryEntry(
        term: 'Adductor Muscle',
        definition: 'Ang malakas na kalamnan sa loob ng talaba na nagkokontrol sa pagbubukas at pagsasara ng shell. Ito ay nagpoprotekta sa talaba mula sa mga mandaragit.',
        category: 'biology',
        relatedTerms: ['Shell', 'Protection', 'Predators'],
      ),
      DictionaryEntry(
        term: 'Mantle',
        definition: 'Ang layer ng tissue sa loob ng shell na nagpoprodukta ng bagong shell material at nagpapalaki sa talaba.',
        category: 'biology',
        relatedTerms: ['Shell', 'Growth', 'Anatomy'],
      ),
      DictionaryEntry(
        term: 'Sessile',
        definition: 'Ang katangian ng talaba na hindi lumilipat ng lugar. Ang mga talaba ay kumakapit sa isang ibabaw at nananatili doon sa buong buhay.',
        category: 'biology',
        relatedTerms: ['Attachment', 'Habitat', 'Mobility'],
      ),
      DictionaryEntry(
        term: 'Bivalve Mollusks',
        definition: 'Ang grupo ng mga invertebrate na may dalawang shell na konektado sa hinge. Kabilang dito ang talaba, clams, at mussels.',
        category: 'biology',
        relatedTerms: ['Mollusca', 'Invertebrates', 'Shell'],
      ),
      DictionaryEntry(
        term: 'Estuaries',
        definition: 'Ang lugar kung saan ang tubig na tabang at katubigan ay naghahalo, na naglilikha ng perpektong kapaligiran para sa paglaki ng talaba.',
        category: 'environment',
        relatedTerms: ['Habitat', 'Coastal Waters', 'Brackish Water'],
      ),
      DictionaryEntry(
        term: 'Filter Feeders',
        definition: 'Ang mga organismo na kumakain sa pamamagitan ng pagfi-filter ng tubig upang kunin ang mga maliliit na particle ng pagkain.',
        category: 'biology',
        relatedTerms: ['Plankton', 'Gill', 'Water Quality'],
      ),
      DictionaryEntry(
        term: 'Cilia',
        definition: 'Mga maliliit na hair-like na istruktura sa gills ng talaba na tumutulong sa paglipat ng pagkain patungo sa bibig.',
        category: 'biology',
        relatedTerms: ['Gill', 'Feeding', 'Microscopic'],
      ),
      DictionaryEntry(
        term: 'Pearl-producing Oysters',
        definition: 'Ang mga uri ng talaba na maaaring magprodyus ng perlas kapag may foreign object ang pumasok sa kanilang shell.',
        category: 'biology',
        relatedTerms: ['Pearls', 'Species', 'Valuable'],
      ),
      DictionaryEntry(
        term: 'Invertebrates',
        definition: 'Ang mga hayop na walang backbone o spinal column. Ang mga talaba ay kabilang sa grupong ito.',
        category: 'biology',
        relatedTerms: ['Vertebrates', 'Animals', 'Classification'],
      ),
      DictionaryEntry(
        term: 'Phylum Mollusca',
        definition: 'Ang malaking grupo ng mga invertebrate na kinabibilangan ng talaba, snails, clams, at squid.',
        category: 'biology',
        relatedTerms: ['Classification', 'Bivalves', 'Marine Life'],
      ),
      DictionaryEntry(
        term: 'Dissolved Oxygen',
        definition: 'Ang oxygen na natutunaw sa tubig na kailangan ng mga talaba para sa paghinga.',
        category: 'environment',
        relatedTerms: ['Water Quality', 'Respiration', 'Oxygen Levels'],
      ),
      DictionaryEntry(
        term: 'Algal Bloom',
        definition: 'Ang biglaang pagdami ng algae sa tubig na maaaring maging sanhi ng polusyon at pagkamatay ng mga organismo.',
        category: 'environment',
        relatedTerms: ['Pollution', 'Red Tide', 'Water Quality'],
      ),
      DictionaryEntry(
        term: 'Red Tide',
        definition: 'Ang kondisyon kung saan ang tubig ay nagiging kulay pula dahil sa sobrang algae, na maaaring maging sanhi ng pagkamatay ng mga talaba at ibang organismo.',
        category: 'environment',
        relatedTerms: ['Algal Bloom', 'Toxins', 'Marine Hazards'],
      ),
      DictionaryEntry(
        term: 'Stake Method',
        definition: 'Ang paraan ng pag-aalaga ng talaba kung saan ang mga poste ng kawayan ay itinanim sa mababaw na tubig at ang mga talaba ay kumakapit dito.',
        category: 'farming',
        relatedTerms: ['Hanging Method', 'Farming Techniques', 'Structures'],
      ),
      DictionaryEntry(
        term: 'Hanging Method',
        definition: 'Ang paraan ng pag-aalaga kung saan ang mga shell ay itinali sa mga lubid na nakasabit sa tubig.',
        category: 'farming',
        relatedTerms: ['Stake Method', 'Long Line', 'Farming Techniques'],
      ),
      DictionaryEntry(
        term: 'Tray/Basket Method',
        definition: 'Ang paggamit ng mga container o basket na nakasabit sa tubig upang paglakiin ang mga talaba.',
        category: 'farming',
        relatedTerms: ['Farming Techniques', 'Containers', 'Growth'],
      ),
      DictionaryEntry(
        term: 'Sedimentasyon',
        definition: 'Ang pag-accumulated ng putik o sediment sa ibabaw ng tubig o sa mga talaba, na maaaring makaapekto sa kanilang kalusugan.',
        category: 'environment',
        relatedTerms: ['Water Quality', 'Pollution', 'Maintenance'],
      ),
      DictionaryEntry(
        term: 'Mandaragit',
        definition: 'Ang mga hayop o organismo na kumakain ng talaba, tulad ng alimango, suso, at bituin ng dagat.',
        category: 'biology',
        relatedTerms: ['Predators', 'Pests', 'Protection'],
      ),
      DictionaryEntry(
        term: 'Settlement',
        definition: 'Ang proseso kung saan ang mga larva ng talaba ay kumakapit sa isang ibabaw upang magsimulang lumaki.',
        category: 'biology',
        relatedTerms: ['Spat', 'Attachment', 'Larva'],
      ),
      DictionaryEntry(
        term: 'Polusyon',
        definition: 'Ang kontaminasyon ng tubig sa pamamagitan ng kemikal, basura, o ibang mapaminsalang substance na maaaring pumatay sa mga talaba.',
        category: 'environment',
        relatedTerms: ['Water Quality', 'Contamination', 'Hazards'],
      ),
      DictionaryEntry(
        term: 'Overcrowding',
        definition: 'Ang kondisyon kung saan ang mga talaba ay masyadong marami sa isang lugar, na nagiging sanhi ng mabagal na paglaki at kompetisyon sa pagkain.',
        category: 'farming',
        relatedTerms: ['Density', 'Growth', 'Management'],
      ),
    ];
  }
}
