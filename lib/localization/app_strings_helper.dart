import 'package:ostrea/localization/app_strings.dart';
import 'package:ostrea/localization/app_strings_en.dart';
import 'package:ostrea/services/localization_service.dart';

class AppStringsHelper {
  static final LocalizationService _localizationService = LocalizationService();

  static String get navHome =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.navHome : AppStrings.navHome;
  static String get navLearn =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.navLearn : AppStrings.navLearn;
  static String get navTroubleshoot =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.navTroubleshoot : AppStrings.navTroubleshoot;
  static String get navIdentify =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.navIdentify : AppStrings.navIdentify;
  static String get navSettings =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.navSettings : AppStrings.navSettings;

  static String get titleOysterFarming =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.titleOysterFarming : AppStrings.titleOysterFarming;
  static String get titleLearningModules =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.titleLearningModules : AppStrings.titleLearningModules;
  static String get titleTroubleshooting =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.titleTroubleshooting : AppStrings.titleTroubleshooting;
  static String get titleSpeciesID =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.titleSpeciesID : AppStrings.titleSpeciesID;
  static String get titleSettings =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.titleSettings : AppStrings.titleSettings;

  static String get homeTitle =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.homeTitle : AppStrings.homeTitle;
  static String get homeSubtitle =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.homeSubtitle : AppStrings.homeSubtitle;
  static String get quickLinksTitle =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.quickLinksTitle : AppStrings.quickLinksTitle;
  static String get speciesTitle =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.speciesTitle : AppStrings.speciesTitle;
  static String get speciesInstructions =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.speciesInstructions : AppStrings.speciesInstructions;
  static String get goodLighting =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.goodLighting : AppStrings.goodLighting;
  static String get takePhoto =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.takePhoto : AppStrings.takePhoto;
  static String get uploadFromGallery =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.uploadFromGallery : AppStrings.uploadFromGallery;
  static String get identifyResult =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.identifyResult : AppStrings.identifyResult;
  static String get confidence =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.confidence : AppStrings.confidence;
  static String get allPredictions =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.allPredictions : AppStrings.allPredictions;
  static String get failedToPickImage =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.failedToPickImage : AppStrings.failedToPickImage;
  static String get identificationFailed =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.identificationFailed : AppStrings.identificationFailed;
  static String get noImageSelected =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.noImageSelected : AppStrings.noImageSelected;

  static String get loading =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.loading : AppStrings.loading;
  static String get previous =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.previous : AppStrings.previous;
  static String get next =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.next : AppStrings.next;
  static String get ok =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.ok : AppStrings.ok;
  static String get cause =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.cause : AppStrings.cause;
  static String get solutions =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.solutions : AppStrings.solutions;

  static String get language =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.language : AppStrings.language;
  static String get currentLanguage =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.currentLanguage : AppStrings.currentLanguage;
  static String get selectLanguage =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.selectLanguage : AppStrings.selectLanguage;
  static String get appSettings =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.appSettings : AppStrings.appSettings;
  static String get keyInformation =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.keyInformation : AppStrings.keyInformation;
  static String get optimalConditions =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.optimalConditions : AppStrings.optimalConditions;
  static String get farmingCycle =>
      _localizationService.currentLanguage == 'en' ? AppStringsEn.farmingCycle : AppStrings.farmingCycle;
}
