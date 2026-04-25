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
        title: 'Modyul sa Pag-aalaga ng Talaba',
        description: 'Komprehensibong gabay sa klasipikasyon, tirahan, pag-aalaga, at konserbasyon ng talaba',
        contentSections: [
          'TAGALOG VERSION \nIntroduksyon\nAng oysters, na kilala sa Pilipinas bilang talaba, ay mga lamang-dagat na naninirahan sa karagatan, baybayin, at mga lugar na malapit sa dagat. Sila ay kabilang sa grupo ng mga hayop na tinatawag na bivalve mollusks. Ang salitang "bivalve" ay nangangahulugang "dalawang shell," na tumutukoy sa dalawang matitigas na kabibe na nagpoprotekta sa malambot nilang katawan.\nKilalang-kilala ang oysters sa buong mundo dahil kinakain sila bilang seafood at mahalaga sila sa pagpapanatili ng malinis na karagatan.\nPara sa maraming komunidad sa baybayin, ang oysters ay hindi lang pagkain. Isa rin itong pinagkakakitaan at kabuhayan. Maraming pamilya ang umaasa sa pag-aalaga at pagkuha ng oysters sa kanilang pang-araw-araw na buhay. Sa mga bansang tulad ng Pilipinas, China, Japan, at United States, maraming oysters ang pinapalago at inaani taon-taon.\nBukod sa halaga nito sa ekonomiya, mahalaga rin ang oysters sa kalikasan. Nililinis nila ang tubig sa pamamagitan ng pagsala ng maliliit na dumi at organismo. Dahil dito, tinatawag silang natural water filters. Pinag-aaralan sila ng mga siyentipiko upang mas maintindihan kung paano nila napoprotektahan ang karagatan.\nAng modyul na ito ay tutulong sa mga estudyante na maintindihan ang oysters sa simple at malinaw na paraan. Ipapaliwanag dito ang kanilang katangian, tirahan, life cycle, kahalagahan, at kung paano sila inaalagaan at pinoprotektahan.\n\nMga Layunin sa Pagkatuto\nPagkatapos pag-aralan ang modyul na ito, inaasahang kaya mong:\nIpaliwanag kung ano ang oyster at paano ito ikinoklasipika \nIlarawan ang pisikal na anyo ng oysters \nTukuyin kung saan sila nakatira at paano nabubuhay \nMaunawaan ang kanilang life cycle at reproduction \nIpaliwanag ang kahalagahan nila sa kapaligiran \nIlarawan ang oyster farming at tulong nito sa komunidad \nTukuyin ang mga banta sa oysters at paraan ng pagprotekta \n\nLesson 1: Pag-uuri ng Oysters (Classification)\nAng oysters ay kabilang sa kaharian ng hayop at tinatawag na marine invertebrates.\nAng invertebrates ay mga hayop na walang gulugod. Kabilang sila sa phylum na Mollusca, kasama ang tulya, tahong, at suso.\nAng oysters ay kabilang sa class na Bivalvia, ibig sabihin may dalawang shell na nakakabit sa isa\'t isa. Ang shell ay gawa sa calcium carbonate kaya matigas at matibay.\nMay iba\'t ibang uri ng oysters sa buong mundo. Ang iba ay kinakain, at ang iba naman ay gumagawa ng perlas.\n\nLesson 2: Pisikal na Istruktura ng Oysters\nAng pinaka-nakikitang bahagi ay ang shell. Ito ay may dalawang bahagi na tinatawag na valves.\nSa loob nito ay ang malambot na katawan. May bahagi na tinatawag na mantle na gumagawa ng shell habang lumalaki ang oyster.\nMayroon ding gills na tumutulong sa paghinga at pagkain. Dito pumapasok ang tubig at kinukuha ang oxygen at pagkain.\nAng adductor muscle naman ang nagpapasara ng shell kapag may panganib.\n\nLesson 3: Tirahan ng Oysters (Habitat)\nKaraniwang matatagpuan ang oysters sa mga lugar na may halong alat at tabang na tubig na tinatawag na estuaries.\nDumikit sila sa matitigas na bagay tulad ng bato o kahoy at nananatili doon. Kaya tinatawag silang sessile animals.\nKapag nagsama-sama sila, bumubuo sila ng oyster reefs na tirahan ng ibang hayop tulad ng isda at alimango.\n\nLesson 4: Paraan ng Pagkain (Feeding Behavior)\nAng oysters ay filter feeders.\nKinukuha nila ang pagkain sa tubig tulad ng plankton. Dumadaan ito sa gills at dinadala sa bibig gamit ang cilia.\nDahil dito, nakakatulong silang linisin ang tubig.\n\nLesson 5: Life Cycle ng Oysters\nNagsisimula ito sa spawning kung saan naglalabas ng itlog at semilya.\nNagiging larvae ang fertilized egg at lumulutang sa tubig.\nKapag nakakita ng matitirhan, didikit ito at tatawaging spat.\nUnti-unti itong lalaki hanggang maging adult.\n\nLesson 6: Kahalagahan ng Oysters\nNililinis ang tubig \nNagbibigay tirahan sa ibang hayop \nPinoprotektahan ang baybayin laban sa alon \n\nLesson 7: Oyster Farming\nAng oyster farming ay pag-aalaga ng oysters para sa pagkain at negosyo.\nNilalagay ang spat sa cages o tali sa tubig.\nHindi nila kailangan ng pakain dahil kumukuha sila ng pagkain sa tubig.\n\nLesson 8: Nutrisyon ng Oysters\nMayaman sa:\nProtein \nZinc \nIron \nVitamin B12 \nNakakatulong ito sa kalusugan.\n\nLesson 9: Mga Banta sa Oysters\nPolusyon sa tubig \nPagkasira ng tirahan \nClimate change \n\nLesson 10: Proteksyon at Konserbasyon\nPagbabalik ng oyster reefs \nPagbawas ng polusyon \nTamang paraan ng farming\n\nLesson 11: Mga Batayan ng Oyster Farming\nAng araling ito ay tungkol sa mga pangunahing kaalaman sa pag-aalaga ng oysters.Mga dapat matutunan:\nAno ang oyster farming \nBakit ito mahalaga sa tao \nPaano pinapalaki ang oysters \n\nLesson 12: Pagpili ng Lugar (Site Selection)\nIpinaliliwanag dito kung paano pumili ng tamang lugar.\nMga dapat matutunan:\nTamang kondisyon ng tubig \nPag-unawa sa alat at temperatura \nPagkilala sa malinis at ligtas na lugar \n\nLesson 13: Iba\'t ibang Paraan ng Pagpapalaki\nTinutukoy ang iba\'t ibang paraan ng pagpapalaki ng oysters.\nMga dapat matutunan:\nStake method, hanging method, at long line method \nAlin ang pinakaangkop na paraan \nPaano inilalagay ang oysters sa tubig \n\nLesson 14: Reproduction at Paglaki\nPinapaliwanag kung paano dumadami at lumalaki ang oysters.\nMga dapat matutunan:\nProseso ng spawning \nMga yugto ng paglaki \nGaano katagal bago lumaki \n\nLesson 15: Maintenance (Pag-aalaga)\nNakatuon sa pag-aalaga ng oyster farm.\nMga dapat matutunan:\nPaano panatilihin ang mga kagamitan \nProseso ng paglilinis \nParaan ng pagprotekta sa oysters \n\nLesson 16: Harvesting (Pag-aani)\nPinapaliwanag ang tamang pag-aani ng oysters.\nMga dapat matutunan:\nKailan dapat mag-ani \nTamang laki para ibenta \nMaayos na paghawak ng oysters \n\nLesson 17: Kahalagahang Pang-ekonomiya\nTinutukoy ang ambag ng oysters sa kabuhayan.\nMga dapat matutunan:\nBenepisyo sa kabuhayan \nHalaga sa merkado \nPapel sa ekonomiya \n\nLesson 18: Kahalagahang Pangkalikasan\nPinapakita kung paano nakakatulong ang oysters sa kalikasan.\nMga dapat matutunan:\nPagsala ng tubig \nBenepisyo sa tirahan ng hayop \nPapel sa ecosystem \n\nLesson 19: Mga Banta sa Oysters\nTinutukoy ang mga problemang kinakaharap ng oysters.\nMga dapat matutunan:\nEpekto ng polusyon \nEpekto ng climate change \nMga panganib tulad ng red tide \n\nLesson 20: Konserbasyon\nNakatuon sa pagprotekta sa oysters.\nMga dapat matutunan:\nMga paraan ng pangangalaga \nSustainable farming \nKahalagahan ng konserbasyon \n\nLesson 21: Mga Batayan ng Oyster Farming\nMga dapat matutunan:\nAno ang oyster farming \nBakit ito mahalaga \nPaano magpalago ng oysters \n\nLesson 22: Pagpili ng Lugar\nMga dapat matutunan:\nTamang kondisyon ng tubig \nAlat at temperatura \nMalinis na lugar \n\nLesson 23: Iba\'t ibang Paraan\nMga dapat matutunan:\nStake, hanging, at long line \nTamang paraan \nPaglalagay sa tubig \n\nLesson 24: Reproduction at Growth\nMga dapat matutunan:\nSpawning \nYugto ng paglaki \nTagal ng paglaki \n\nLesson 25: Maintenance\nMga dapat matutunan:\nPag-aalaga \nPaglilinis \nProteksyon \n\nLesson 26: Harvesting\nMga dapat matutunan:\nKailan aanihin \nTamang laki \nMaayos na paghawak \n\nLesson 27: Kahalagahang Pang-ekonomiya\nMga dapat matutunan:\nKabuhayan \nHalaga sa merkado \nPapel sa ekonomiya \n\nLesson 28: Kahalagahang Pangkalikasan\nMga dapat matutunan:\nPagsala ng tubig \nTirahan ng hayop \nEcosystem \n\nLesson 29: Mga Banta\nMga dapat matutunan:\nPolusyon \nClimate change \nRed tide \n\nLesson 30: Konserbasyon\nMga dapat matutunan:\nPangangalaga',
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
        term: 'Aquakultura',
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
        term: 'Brankya',
        definition: 'Ang organ ng talaba na ginagamit para sa paghinga at pagkain. Ito ay nagfi-filter ng oxygen at plankton mula sa tubig.',
        category: 'biology',
        relatedTerms: ['Filter Feeders', 'Respirasyon', 'Cilia'],
      ),
      DictionaryEntry(
        term: 'Kalamnan ng Adductor',
        definition: 'Ang malakas na kalamnan sa loob ng talaba na nagkokontrol sa pagbubukas at pagsasara ng shell. Ito ay nagpoprotekta sa talaba mula sa mga mandaragit.',
        category: 'biology',
        relatedTerms: ['Shell', 'Proteksyon', 'Mga Mandaragit'],
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
        term: 'Pamamaraang Stake',
        definition: 'Ang paraan ng pag-aalaga ng talaba kung saan ang mga poste ng kawayan ay itinanim sa mababaw na tubig at ang mga talaba ay kumakapit dito.',
        category: 'farming',
        relatedTerms: ['Pamamaraang Hanging', 'Teknik ng Pag-aalaga', 'Mga Istruktura'],
      ),
      DictionaryEntry(
        term: 'Pamamaraang Hanging',
        definition: 'Ang paraan ng pag-aalaga kung saan ang mga shell ay itinali sa mga lubid na nakasabit sa tubig.',
        category: 'farming',
        relatedTerms: ['Pamamaraang Stake', 'Long Line', 'Teknik ng Pag-aalaga'],
      ),
      DictionaryEntry(
        term: 'Pamamaraang Tray/Basket',
        definition: 'Ang paggamit ng mga container o basket na nakasabit sa tubig upang paglakiin ang mga talaba.',
        category: 'farming',
        relatedTerms: ['Teknik ng Pag-aalaga', 'Mga Container', 'Paglaki'],
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
