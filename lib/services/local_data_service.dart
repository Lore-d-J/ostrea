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

  Future<List<LearningModule>> getLearningModules() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_learningModulesKey);

    if (jsonString == null) {
      final modules = _getDefaultLearningModules();
      await _saveLearningModules(modules);
      return modules;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      final modules = json.map((item) => LearningModule(
        id: item['id']?.toString() ?? '',
        title: item['title']?.toString() ?? 'Walang Pamagat',
        description: item['description']?.toString() ?? '',
        contentSections: List<String>.from(item['content_sections'] ?? const []),
        imageAsset: item['image_asset']?.toString(),
        videoAsset: item['video_asset']?.toString(),
        hasVoiceNarration: item['has_voice_narration'] ?? true,
      )).toList();

      if (modules.isEmpty || modules.any((module) => module.id.isEmpty)) {
        final defaultModules = _getDefaultLearningModules();
        await _saveLearningModules(defaultModules);
        return defaultModules;
      }

      return modules;
    } catch (_) {
      final defaultModules = _getDefaultLearningModules();
      await _saveLearningModules(defaultModules);
      return defaultModules;
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

  Future<List<TroubleshootingGuide>> getTroubleshootingGuides() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_troubleshootingGuidesKey);

    if (jsonString == null) {
      final guides = _getDefaultTroubleshootingGuides();
      await _saveTroubleshootingGuides(guides);
      return guides;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((item) => TroubleshootingGuide(
        id: item['id']?.toString() ?? '',
        title: item['title']?.toString() ?? 'Walang Pamagat',
        problem: item['problem']?.toString() ?? '',
        cause: item['cause']?.toString() ?? '',
        solutions: List<String>.from(item['solutions'] ?? const []),
        imageAsset: item['image_asset']?.toString(),
        videoAsset: item['video_asset']?.toString(),
        severity: item['severity']?.toString() ?? 'medium',
      )).toList();
    } catch (_) {
      final defaultGuides = _getDefaultTroubleshootingGuides();
      await _saveTroubleshootingGuides(defaultGuides);
      return defaultGuides;
    }
  }

  Future<void> _saveTroubleshootingGuides(List<TroubleshootingGuide> guides) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(guides.map((guide) => {
      'id': guide.id,
      'title': guide.title,
      'problem': guide.problem,
      'cause': guide.cause,
      'solutions': guide.solutions,
      'image_asset': guide.imageAsset,
      'video_asset': guide.videoAsset,
      'severity': guide.severity,
    }).toList());
    await prefs.setString(_troubleshootingGuidesKey, json);
  }

  Future<List<Map<String, dynamic>>> getMapLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_mapLocationsKey);

    if (jsonString == null) {
      final locations = _getDefaultMapLocations();
      await _saveMapLocations(locations);
      return locations;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (_) {
      final defaultLocations = _getDefaultMapLocations();
      await _saveMapLocations(defaultLocations);
      return defaultLocations;
    }
  }

  Future<void> _saveMapLocations(List<Map<String, dynamic>> locations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mapLocationsKey, jsonEncode(locations));
  }

  Future<List<DictionaryEntry>> getDictionaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_dictionaryKey);

    if (jsonString == null) {
      final entries = _getDefaultDictionaryEntries();
      await _saveDictionaryEntries(entries);
      return entries;
    }

    try {
      final List<dynamic> json = jsonDecode(jsonString);
      return json.map((item) => DictionaryEntry(
        term: item['term']?.toString() ?? '',
        definition: item['definition']?.toString() ?? '',
        category: item['category']?.toString() ?? 'general',
        relatedTerms: List<String>.from(item['related_terms'] ?? const []),
      )).toList();
    } catch (_) {
      final defaultEntries = _getDefaultDictionaryEntries();
      await _saveDictionaryEntries(defaultEntries);
      return defaultEntries;
    }
  }

  Future<void> _saveDictionaryEntries(List<DictionaryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(entries.map((entry) => {
      'term': entry.term,
      'definition': entry.definition,
      'category': entry.category,
      'related_terms': entry.relatedTerms,
    }).toList());
    await prefs.setString(_dictionaryKey, json);
  }

  List<LearningModule> _getDefaultLearningModules() {
    return [
      LearningModule(
        id: 'module1',
        title: 'Aralin 1: Pagkilala sa Talaba',
        description: 'Alamin ang talaba at ang kahalagahan ng tamang pag-aalaga nito.',
        contentSections: [
          'Ano ang talaba?\nAng talaba ay isang uri ng kabibe na karaniwang inaalagaan sa maalat o bahagyang maalat na tubig.\n\nAng talaba ay kumukumuha ito ng pagkain sa tubig sa pamamagitan ng pagsala gamit ang hasang.',
          'Bakit mahalaga ang pag-aalaga ng talaba?\nAng pag-aalaga ng talaba ay maaaring maging pinagkukunan ng pagkain at kabuhayan para sa mga mangingisda at magsasaka sa baybayin.',
          'Tandaan:\nAng talaba ay umaasa sa natural na pagkain na nasa tubig, kaya mahalaga ang malinis at maayos na kondisyon ng lugar.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module2',
        title: 'Aralin 2: Pagpili ng Lugar',
        description: 'Alamin kung saan dapat itayo ang talabahan.',
        contentSections: [
          'Ano ang magandang lugar para sa talaba?\nMas mainam ang lugar na may maalat hanggang bahagyang maalat na tubig at sapat na lalim kahit mababa ang tubig.\n\nAyon sa BFAR, ang angkop na alat ng tubig ay humigit-kumulang 15 hanggang 26 ppt, habang ang temperatura ay nasa 20 hanggang 30°C.',
          'Ang magandang lugar ay:\n- Malinis at walang polusyon\n- Hindi madaling bahain\n- Hindi masyadong malakas ang alon\n- May sapat na lalim\n- May natural na suplay ng maliliit na talaba o spat',
          'Tandaan:\nPiliin ang lugar na malinis, protektado, at angkop sa kondisyon ng tubig.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module3',
        title: 'Aralin 3: Pagkuha ng Spat o Binhing Talaba',
        description: 'Paano makukuha at ilalagay ang spat o binhi ng talaba?',
        contentSections: [
          'Ano ang spat?\nAng spat ay maliliit na talaba na nagsisimulang kumapit sa isang angkop na bagay sa tubig.\n\nKaraniwang ginagamit ang walang lamang balat ng talaba bilang pamitan ng spat.',
          'Paano ito ginagawa?\n1. Maghanda ng malinis na balat ng talaba.\n2. Itali o ayusin ang mga ito bilang pamitan.\n3. Ilagay sa angkop na lugar sa tubig.\n4. Hintaying kumapit ang maliliit na talaba.\n5. Regular na tingnan ang mga pamitan.',
          'Tandaan:\nAng malinis at maayos na pamitan ay mahalaga para sa pagkakaroon ng spat.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module4',
        title: 'Aralin 4: Paraan ng Pag-aalaga',
        description: 'Iba-ibang paraan ng pagtatanim at pag-aalaga ng talaba.',
        contentSections: [
          'Iba-ibang paraan\nMay ilang paraan ng pag-aalaga ng talaba:\n\n- Tulos\n- Pabitin\n- Sampayan\n- Parangit\nSa materyal ng BFAR, ang paraan na pabitin ang inirerekomenda.',
          'Paraan na pabitin\nAng mga pamiitan ay isinasabit sa isang istrukturang kawayan o kahoy.\n\nDapat may sapat na pagitan ang mga pamitan upang magkaroon ng maayos na daloy ng tubig.',
          'Tandaan:\nHuwag pagsiksikin ang mga pamiitan.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module5',
        title: 'Aralin 5: Pangangalaga sa Talabahan',
        description: 'Paano regular na suriin at pangalagaan ang talabahan?',
        contentSections: [
          'Regular na suriin\nRegular na tingnan ang buong istruktura ng talabahan.',
          'Tingnan ang:\nKawayan at poste\nLubid at tali\nMga talaba\nKondisyon ng tubig\n\nKapag may sirang bahagi, ayusin o palitan agad kung kinakailangan.',
          'Tandaan:\nMas madaling ayusin ang maliit na problema bago ito lumaki.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module6',
        title: 'Aralin 6: Pag-alis ng Espongha',
        description: 'Paano alisin ang espongha sa ibabaw ng talaba?',
        contentSections: [
          'Problema\nMaaaring tumubo ang espongha sa ibabaw ng balat ng talaba.',
          'Bakit ito dapat alisin?\nMaaaring hadlangan ng espongha ang daloy ng tubig at pagkain. Maaari rin itong makipag-agawan sa talaba para sa oxygen at pagkain.',
          'Ano ang gagawin?\n1. Suriin ang mga talaba.\n2. Hanapin ang tumutubong espongha.\n3. Alisin ito sa ibabaw ng balat ng talaba.\n4. Regular na suriin muli.',
          'Babala:\nHuwag hayaang sobrang dumami ang espongha ng talaba.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module7',
        title: 'Aralin 7: Tamang Posisyon ng Talaba',
        description: 'Paano dapat nakaposisyon ang mga talaba sa pabitin?',
        contentSections: [
          'Saan dapat nakaposisyon ang talaba?\nAng mga nakabitin na talaba ay dapat nasa ibaba lamang ng karaniwang pinakamababang lebel ng tubig.',
          'Ano ang gagawin?\nRegular na tingnan ang taas ng mga nakabitin na pamitan.\n\nKung kinakailangan, ayusin ang pagkakasabit ng mga ito.',
          'Tandaan:\nPanatilihing maayos ang posisyon ng mga nakabitin na talaba.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module8',
        title: 'Aralin 8: Paglaki ng Talaba',
        description: 'Paano kumakain at lumaki ang talaba?',
        contentSections: [
          'Paano kumakain ang talaba?\nSinasala ng talaba ang tubig upang makakuha ng pagkain tulad ng maliliit na organismo, phytoplankton, at organikong bagay.',
          'Gaano katagal bago lumaki?\nAyon sa BFAR material, karaniwang umaabot sa 6 hanggang 10 buwan mula sa paglalagay ng binhi bago maging sapat ang gulang ng talaba.',
          'Tandaan:\nMahalaga ang magandang kondisyon ng tubig para sa paglaki ng talaba.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module9',
        title: 'Aralin 9: Pag-aani ng Talaba',
        description: 'Paano mag-aani ng talaba nang tama?',
        contentSections: [
          'Kailan maaaring mag-ani?\nMaaaring paghiwalayin ang malalaking talaba para ibenta habang iniiwan ang maliliit upang patuloy na lumaki.',
          'Paano mag-ani?\n1. Hilahin ang mga nakabitin na linya.\n2. Paghiwalayin ang malalaki at maliliit na talaba.\n3. Ibalik ang maliliit sa lugar na patuloy silang lalago.\n4. Linisin ang mga naaning talaba.\n5. Ilagay sa angkop na lalagyan.',
          'Tandaan:\nHuwag anihin lahat kung may maliliit pang talaba na maaari pang lumaki.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module10',
        title: 'Aralin 10: Kaligtasan sa Pag-aani',
        description: 'Ano ang dapat gawin kapag may red tide?',
        contentSections: [
          'Red Tide\nKapag may red tide sa lugar, kailangang itigil o ipagpaliban ang pag-aani.\n\nMaaaring maging sanhi ng pagkalason sa tao ang pagkain ng talaba mula sa lugar na apektado ng red tide.',
          'Ano ang gagawin?\nHuwag mag-ani.\n\nMaghintay hanggang ma-clear ang lugar at masabing ligtas na muli ang pag-aani.',
          'Tandaan:\nMay red tide, huwag mag-ani.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.webm',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module11',
        title: 'Aralin 11: Tamang Pag-aalaga sa Talabahan',
        description: 'Araw-araw na paalala sa tamang pag-aalaga ng talaba.',
        contentSections: [
          'Araw-araw na paalala\nHindi kailangang komplikado ang pag-aalaga ng talaba.\n\nAng mahalaga ay regular na:\n- Suriin ang istruktura.\n- Tingnan ang kondisyon ng mga talaba.\n- Alisin ang espongha.\n- Ayusin ang sirang bahagi.\n- Bantayan ang kondisyon ng tubig.\n- Bantayan ang lugar laban sa pagnanakaw.',
          'Tandaan:\nRegular na pagbisita at pagsuri sa talabahan ang susi sa maayos na pamamahala.',
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
        id: 'guide1',
        title: 'Maraming namamatay na talaba',
        problem: 'Suriin ang tubig at kung may pagbaha.',
        cause: 'Maaaring bumaba nang husto ang alat ng tubig kapag bumaha.',
        solutions: [
          'Suriin ang tubig at kung may pagbaha.',
          'Maaaring bumaba nang husto ang alat ng tubig kapag bumaha.',
        ],
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'guide2',
        title: 'May tumutubong espongha',
        problem: 'Alisin ang espongha sa balat ng talaba.',
        cause: 'Maaaring makaapekto ito sa daloy ng tubig, pagkain, at oxygen.',
        solutions: [
          'Alisin ang espongha sa balat ng talaba.',
          'Maaaring makaapekto ito sa daloy ng tubig, pagkain, at oxygen.',
        ],
        severity: 'medium',
      ),
      TroubleshootingGuide(
        id: 'guide3',
        title: 'Nasira ang istruktura',
        problem: 'Suriin ang kawayan, poste, lubid, at platform.',
        cause: 'Ayusin o palitan agad ang sirang bahagi.',
        solutions: [
          'Suriin ang kawayan, poste, lubid, at platform.',
          'Ayusin o palitan agad ang sirang bahagi.',
        ],
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'guide4',
        title: 'Malakas ang alon o hangin',
        problem: 'Suriin ang mga poste at nakasabit na pamitan.',
        cause: 'Ayusin ang anumang nasira.',
        solutions: [
          'Suriin ang mga poste at nakasabit na pamitan.',
          'Ayusin ang anumang nasira.',
          'Para sa pagpili ng lugar, mas mainam ang mga lugar na protektado laban sa malakas na hangin at alon.',
        ],
        severity: 'medium',
      ),
      TroubleshootingGuide(
        id: 'guide5',
        title: 'Bumaha sa lugar',
        problem: 'Suriin ang kondisyon ng tubig at dami ng putik.',
        cause: 'Maaaring magdulot ang pagbaha ng mababang alat at matinding pag-ipon ng putik.',
        solutions: [
          'Suriin ang kondisyon ng tubig at dami ng putik.',
          'Maaaring magdulot ang pagbaha ng mababang alat at matinding pag-ipon ng putik.',
        ],
        severity: 'high',
      ),
      TroubleshootingGuide(
        id: 'guide6',
        title: 'May red tide',
        problem: 'ITIGIL ANG PAG-AANI.',
        cause: 'Huwag kumain o magbenta ng talaba mula sa apektadong lugar hanggang ma-clear ito.',
        solutions: [
          'ITIGIL ANG PAG-AANI.',
          'Huwag kumain o magbenta ng talaba mula sa apektadong lugar hanggang ma-clear ito.',
        ],
        severity: 'critical',
      ),
    ];
  }

  List<Map<String, dynamic>> _getDefaultMapLocations() {
    return [
      {
        'name': 'Talabahan sa Baybayin',
        'description': 'Pangunahing lugar ng pag-aalaga at pag-aani ng talaba.',
        'latitude': 14.5995,
        'longitude': 120.9842,
        'type': 'oyster_farm',
      },
      {
        'name': 'Protektadong Lawa',
        'description': 'Lugar na may maayos na daloy ng tubig at tamang kondisyon para sa talaba.',
        'latitude': 13.9414,
        'longitude': 121.1543,
        'type': 'protected_area',
      },
      {
        'name': 'Barangay Nursery',
        'description': 'Lugar kung saan hinihintay ang mga spat bago ilagay sa pangkalahatang pamitan.',
        'latitude': 14.1740,
        'longitude': 121.2424,
        'type': 'nursery',
      },
    ];
  }

  List<DictionaryEntry> _getDefaultDictionaryEntries() {
    return [
      DictionaryEntry(
        term: 'Spat',
        definition: 'Maliliit na talaba na nagsisimulang kumapit sa isang angkop na bagay sa tubig.',
        category: 'farming',
        relatedTerms: ['binhi', 'pamitan', 'talaba'],
      ),
      DictionaryEntry(
        term: 'Pabitin',
        definition: 'Paraan ng pag-aalaga kung saan ang mga pamitan ay isinasabit sa istruktura na nakataas sa tubig.',
        category: 'farming',
        relatedTerms: ['pamitan', 'talabahan'],
      ),
      DictionaryEntry(
        term: 'Red Tide',
        definition: 'Kondisyon kung saan may sobrang dami ng algae na maaaring magdulot ng kontaminasyon at panganib sa tao.',
        category: 'environment',
        relatedTerms: ['kaligtasan', 'pag-aani', 'water quality'],
      ),
      DictionaryEntry(
        term: 'Hasang',
        definition: 'Parte ng talaba na ginagamit upang salain ang tubig at kunin ang pagkain.',
        category: 'biology',
        relatedTerms: ['pagkain', 'talaba', 'tubig'],
      ),
      DictionaryEntry(
        term: 'Pamiitan',
        definition: 'Lugar o estruktura sa tubig kung saan inilalagay at pinapalaki ang mga talaba. Karaniwan itong gawa sa kawayan, poste, lubid, o iba pang materyales na nagsisilbing suporta sa pagpapalaki ng talaba.',
        category: 'farming',
        relatedTerms: ['pamitan', 'talabahan', 'pabitin', 'talaba'],
      ),
      DictionaryEntry(
        term: 'Espongha',
        definition: '"Sponge" sa ingles, isa itong organismong kumakapit sa mga kagamitan at istruktura sa talabahan.',
        category: 'farming',
        relatedTerms: ['pamitan', 'talabahan', 'pabitin', 'talaba'],
      ),
    ];
  }
}
