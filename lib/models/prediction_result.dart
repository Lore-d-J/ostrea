class PredictionResult {
  final String label;
  final double confidence;
  final String description;
  final String message;

  PredictionResult({
    required this.label,
    required this.confidence,
    this.description = '',
    this.message = '',
  });

  String get confidencePercentage =>
      '${(confidence * 100).toStringAsFixed(1)}%';
}
