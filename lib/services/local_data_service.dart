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
        title: 'Panimula sa Pagpapalaki ng Oyster',
        description: 'Alamin ang mga pangunahing kaalaman sa pagpapalaki at pag-aalaga ng oyster',
        contentSections: [
          'Ang pagpapalago ng oyster ay isa sa pinaka-sustainable na uri ng aquaculture. Ang mga oyster ay filter-feeders na nagpapabuti ng kalidad ng tubig habang nagbibigay ng masustansyang pagkain. Kadalasan, kakaunti lamang ang kailangan nilang feed o kemikal, at makakatulong sila sa pagpapanumbalik ng nasirang marine ecosystem.',
          'May tatlong pangunahing sistema ng pagpapalago ng oyster: pond system, bag system, at cage system. May kani-kaniyang benepisyo ang bawat isa depende sa lokasyon, klima, at pinagkukunang kagamitan. Ang pond system ay madalas na mas madaling simulan para sa mga baguhan.',
          'Ang lifecycle ng oyster farming ay kinabibilangan ng pagpili ng breeding stock, produksyon ng larvae, koleksyon ng spat, pagpapalaki ng juvenile, at pag-grow-out hanggang maging adult. Karaniwang tumatagal ng 2-3 taon mula spat hanggang market-size depende sa species at kondisyon.',
          'Ang matagumpay na pagpapalago ng oyster ay nangangailangan ng masusing pag-monitor sa kalidad ng tubig, temperatura, salinidad, at nutrient levels. Ang araw-araw na pagsubaybay ay nakakatulong maiwasan ang sakit at mapanatili ang optimal na paglaki.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module2',
        title: 'Pamamahala ng Kalidad ng Tubig',
        description: 'Mahalagang parametro para sa malusog na oyster farming',
        contentSections: [
          'Ang kalidad ng tubig ang pundasyon ng matagumpay na oyster farming. Ang apat na kritikal na parametro ay pH, dissolved oxygen, salinity, at temperatura. Dapat panatilihin ang mga ito sa angkop na saklaw para sa kalusugan ng oyster.',
          'Panatilihin ang pH sa pagitan ng 7.5 at 8.5. Sumusuporta ito sa pagbuo ng shell at sa balanseng microbial community. Sukatin ang pH araw-araw gamit ang calibrated meter.',
          'Ang dissolved oxygen (DO) ay dapat manatiling higit sa 5 mg/L para sa kaligtasan ng oyster. Pagandahin ang aeration sa pamamagitan ng pagtaas ng flow, paggamit ng paddle wheels, o pag-install ng air stones. Ang mababang DO ay nagdudulot ng stress at sakit.',
          'Ang salinidad ay nag-iiba ayon sa species. Ang ilang species ay mas gusto ang 10-30 ppt, habang ang iba ay mas komportable sa 20-35 ppt. Gumamit ng refractometer o conductivity meter para bantayan ang salinidad.',
          'Nakaaapekto ang temperatura sa rate ng paglaki at pagkakaroon ng sakit. Ang optimal na saklaw para sa maraming species ay 15-25°C. Iwasan ang biglaang pagbabago ng temperatura upang hindi ma-shock ang mga oyster.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module3',
        title: 'Nutrisyon at Pagpapakain',
        description: 'Unawain ang pangangailangang pandiyeta ng mga oyster',
        contentSections: [
          'Ang mga oyster ay filter-feeders na kumokonsumo ng phytoplankton at zooplankton. Sa natural na sistema, nakakakuha sila ng nutrisyon mula sa water column nang hindi nangangailangan ng dagdag na pagpapakain.',
          'Ang diatoms at flagellates (mga single-celled algae) ang karaniwang pagkain ng mga oyster. Matatagpuan ang mga ito sa malusog na tubig at nagbibigay ng sustansya para sa paglaki ng shell at laman.',
          'Mahalaga ang water flow para sa pagpapakain. Kailangan ng oyster ang sapat na daloy upang dalhin ang mga particle ng pagkain. Inirerekomenda ang flow na 2-3 beses ng volume ng tangke o pond kada oras.',
          'Sa closed systems, maaaring kailanganin ang suplementong pagpapakain gamit ang phytoplankton culture o commercial feeds. Gayunpaman, panatilihin hangga\'t maaari ang natural na mapagkukunan ng pagkain para sa mas malusog na oyster.',
          'Ang palatandaan ng hindi sapat na pagpapakain ay mabagal na paglaki, payat na shell, at mababang kondisyon ng laman. Kung mangyari ito, pagbutihin ang water exchange, aeration, at isaalang-alang ang dagdag na feeds.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module4',
        title: 'Pag-iwas at Pamamahala ng Sakit',
        description: 'Pagtukoy at pag-iwas sa mga karaniwang sakit ng oyster',
        contentSections: [
          'Nahahati ang mga sakit ng oyster sa bacterial infections, parasitic infestations, at viral diseases. Mas epektibo ang pag-iwas sa pamamagitan ng mabuting husbandry kaysa sa paggamot.',
          'Ang pinakaepektibong stratehiya ay ang pagpapanatili ng optimal na kondisyon ng tubig. Ang stressed na oyster dahil sa poor water quality ay madaling kapitan ng sakit.',
          "I-quarantine ang bagong stock bago ilahad sa farm. Suriin para sa karaniwang parasites tulad ng Perkinsus at Bonamia. Huwag paghaluin ang stock mula sa iba't ibang pinagmulan nang walang tamang screening.",
          'Ang shell disease ay makikita bilang brown spots o pagkasira ng shell. Karaniwang sanhi ng bacteria; naiiwasan ito sa pamamagitan ng mababang ammonia, sapat na oxygen, at stable na pH.',
          'Kasama sa mabuting sanitation ang pag-disinfect ng mga kagamitan at tamang pagtatapon ng patay na oyster. Gumamit ng 10% bleach solution o 70% ethanol kung kinakailangan.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module5',
        title: 'Pagkolekta ng Spat at Produksyon ng Seed',
        description: 'Mga teknik sa pagkolekta at pagpapalaki ng spat',
        contentSections: [
          'Ang spat ay mga bagong settle na larvae ng oyster na karaniwang nakokolekta tuwing tagsibol at tag-init. Maaaring hikayatin ang natural spat fall sa pamamagitan ng magandang settlement substrate at tamang kondisyon.',
          'Ang substrate ay maaaring oyster shells, PVC pipes, o specialized collectors. I-condition ang substrate sa pamamagitan ng exposure sa healthy biofilm at tubig na may larvae bago ang season.',
          'Mas maganda ang settlement sa mainit at maayos na halo-halong tubig na may sapat na pagkain. Panatilihin ang temperatura mga 18-20°C at tiyaking may sapat na aeration habang nagsesettle.',
          'May benepisyo ang hatchery-produced spat tulad ng control sa sakit at tuloy-tuloy na supply. Pinapa-trigger ang spawning sa hatchery gamit ang pagbabago ng temperatura at controlled rearing conditions.',
          'Pagkatapos mag-settle, protektahan ang spat mula sa predators at bantayan nang mabuti. Ilipat sa nursery systems matapos ang 2-3 linggo upang mapataas ang survival rate.',
        ],
        imageAsset: null,
        videoAsset: 'assets/videos/placeholder.mp4',
        hasVoiceNarration: true,
      ),
      LearningModule(
        id: 'module6',
        title: 'Pag-optimize ng Paglaki at Pag-aani',
        description: 'Pag-maximize ng paglaki at tamang pamamaraan ng pag-aani',
        contentSections: [
          'Ang rate ng paglaki ay nakadepende sa kalidad ng tubig, availability ng pagkain, temperatura, at stocking density. Sa mabuting kondisyon, karaniwang lumalaki ang ilang oyster ng 2-3 cm kada taon.',
          'Nakaaapekto ang stocking density sa indibidwal na paglaki dahil bumababa ang pagkain kada oyster sa mataas na density. Nag-iiba ang optimal density base sa system, pero karaniwang 100-300 oysters kada square meter.',
          'Nag-iiba ang market size depende sa rehiyon at gamit. Karaniwan, umaabot sa market size (75-100mm) ang oyster sa 2-3 taon. May mga merkado na mas gusto ang mas maliit o mas malaking sukat.',
          'Anihin nang dahan-dahan sa pamamagitan ng pag-alis ng oyster mula sa collectors o culture systems. Huwag sirain ang shell; i-purge sa malinis na tubig ng 24-48 oras bago ibenta upang alisin ang sediment.',
          'Mahalaga ang post-harvest handling. Panatilihin nang malamig at mamasa-masa ang oysters, huwag ilubog sa fresh water. I-ship sa tamang temperatura mga 10-15°C at gumamit ng well-ventilated containers.',
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
