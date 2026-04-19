import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'disease_identification_interface.dart';

class DiseaseIdentificationWeb implements DiseaseIdentificationInterface {
  late List<String> _labels;
  bool _isInitialized = false;

  /// Initialize the service (load labels only)
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load labels from asset
      final labelsData = await rootBundle.loadString('assets/models/disease_labels.txt');
      _labels = labelsData.split('\n').where((line) => line.trim().isNotEmpty).map((line) {
        final parts = line.split(' ');
        return parts.sublist(1).join(' '); // Skip the index
      }).toList();

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize disease identification: $e');
    }
  }

  /// Identify oyster disease from image bytes (demo mode)
  @override
  Future<Map<String, dynamic>> identifyDisease(Uint8List imageBytes) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Decode image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Use demo predictions based on image hash
      final predictions = _generateVariablePredictions(imageBytes);
      final topPredictions = _getTopPredictions(predictions, 3);

      return {
        'disease': topPredictions[0]['label'],
        'confidence': topPredictions[0]['confidence'],
        'allPredictions': topPredictions,
      };
    } catch (e) {
      throw Exception('Disease identification failed: $e');
    }
  }

  /// Generate variable predictions based on image hash for demo purposes
  List<double> _generateVariablePredictions(Uint8List imageBytes) {
    // Use image hash to generate consistent but variable results
    int hash = 0;
    for (int i = 0; i < imageBytes.length; i++) {
      hash = ((hash << 5) - hash) + imageBytes[i];
      hash = hash & hash; // Convert to 32bit integer
    }

    // Create base predictions
    final predictions = List<double>.filled(_labels.length, 0.05);

    // Distribute confidence scores based on hash
    final seed = hash.abs() % 1000;

    // Assign higher confidence to different diseases based on seed
    if (seed < 300) {
      // Healthy Oyster - ~30%
      predictions[0] = 0.75;
      predictions[1] = 0.15;
      predictions[5] = 0.05;
    } else if (seed < 550) {
      // Diseased (Perkinsus) - ~25%
      predictions[1] = 0.70;
      predictions[0] = 0.20;
      predictions[2] = 0.05;
    } else if (seed < 750) {
      // Diseased (Bonamia) - ~20%
      predictions[2] = 0.65;
      predictions[1] = 0.20;
      predictions[3] = 0.10;
    } else if (seed < 900) {
      // Diseased (MSX) - ~15%
      predictions[3] = 0.60;
      predictions[2] = 0.25;
      predictions[1] = 0.10;
    } else {
      // Barnacles or Unknown
      predictions[4] = 0.55; // Barnacles
      predictions[5] = 0.30; // Unknown
      predictions[0] = 0.10;
    }

    return predictions;
  }

  /// Get top N predictions
  List<Map<String, dynamic>> _getTopPredictions(
    List<double> predictions,
    int topN,
  ) {
    final indexed = <Map<String, dynamic>>[];
    for (int i = 0; i < predictions.length; i++) {
      indexed.add({
        'label': _labels[i],
        'confidence': (predictions[i] * 100).toStringAsFixed(2),
      });
    }

    indexed.sort((a, b) {
      final confA = double.parse(a['confidence']);
      final confB = double.parse(b['confidence']);
      return confB.compareTo(confA);
    });

    return indexed.take(topN).toList();
  }

  /// Dispose resources (nothing to dispose on web)
  @override
  void dispose() {
    _isInitialized = false;
  }
}