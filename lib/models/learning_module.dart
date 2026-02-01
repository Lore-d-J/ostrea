class LearningModule {
  final String id;
  final String title;
  final String description;
  final List<String> contentSections;
  final String? imageAsset;
  final String? videoAsset;
  final bool hasVoiceNarration;

  LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.contentSections,
    this.imageAsset,
    this.videoAsset,
    this.hasVoiceNarration = true,
  });
}

class TroubleshootingGuide {
  final String id;
  final String title;
  final String problem;
  final String cause;
  final List<String> solutions;
  final String? imageAsset;
  final String? videoAsset;
  final String severity; // 'low', 'medium', 'high'

  TroubleshootingGuide({
    required this.id,
    required this.title,
    required this.problem,
    required this.cause,
    required this.solutions,
    this.imageAsset,
    this.videoAsset,
    this.severity = 'medium',
  });
}

class SpeciesInfo {
  final int label;
  final String name;
  final String scientificName;
  final String type; // Shell or Meat
  final String description;
  final String characteristics;

  SpeciesInfo({
    required this.label,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.description,
    required this.characteristics,
  });
}
