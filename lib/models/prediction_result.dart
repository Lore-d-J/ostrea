class PredictionResult {
  final String label;
  final double confidence;
  final String description;
  final String message;
  final String condition;
  final String recommendation;

  PredictionResult({
    required this.label,
    required this.confidence,
    this.description = '',
    this.message = '',
    required this.condition,
    required this.recommendation,
  });

  String get confidencePercentage =>
      '${(confidence * 100).toStringAsFixed(1)}%';
}
