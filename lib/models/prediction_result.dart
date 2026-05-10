class PredictionResult {
  final String label;
  final double confidence;

  PredictionResult({required this.label, required this.confidence});

  String get confidencePercentage =>
      '${(confidence * 100).toStringAsFixed(0)}%';
}
