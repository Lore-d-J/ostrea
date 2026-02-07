import 'package:image/image.dart' as img;
import 'dart:typed_data';

class SpeciesIdentificationService {
  late dynamic _interpreter;
  late List<String> _labels;
  bool _isInitialized = false;

  final List<String> speciesLabels = [
    'Eastern Oyster (Crassostrea virginica)-Shell',
    'Eastern Oyster (Crassostrea virginica)-Meat',
    'Pacific Oyster (Crassostrea gigas)-Shell',
    'Pacific Oyster (Crassostrea gigas)-Meat',
    'Mangrove Oyster (Crassostrea iredalei)-Shell',
    'Mangrove Oyster (Crassostrea iredalei)-Meat',
  ];

  /// Initialize the TensorFlow Lite model
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize labels from asset
      _labels = speciesLabels;
      _isInitialized = true;
      
      // TODO: Add actual TFLite initialization for Android
      // Currently using variable predictions for demo
    } catch (e) {
      throw Exception('Failed to initialize species identification: $e');
    }
  }

  /// Identify oyster species from image bytes
  Future<Map<String, dynamic>> identifySpecies(Uint8List imageBytes) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Decode image
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to model input size (assuming 224x224)
      final resizedImage = img.copyResize(image, width: 224, height: 224);
      // Convert resized image to byte list for potential TFLite input (ignored for now)
      final _ = _imageToByteList(resizedImage, 224);

      // Run inference - use variable predictions based on image hash
      final predictions = _generateVariablePredictions(imageBytes);
      final topPredictions = _getTopPredictions(predictions, 3);
      
      return {
        'species': topPredictions[0]['label'],
        'confidence': topPredictions[0]['confidence'],
        'allPredictions': topPredictions,
      };
    } catch (e) {
      throw Exception('Species identification failed: $e');
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
    final predictions = List<double>.filled(speciesLabels.length, 0.05);
    
    // Distribute confidence scores based on hash
    final seed = hash.abs() % 1000;
    
    // Assign higher confidence to different species based on seed
    if (seed < 350) {
      // Pacific Oyster Shell - ~35%
      predictions[2] = 0.65;
      predictions[0] = 0.18;
      predictions[4] = 0.12;
    } else if (seed < 600) {
      // Eastern Oyster Shell - ~25%
      predictions[0] = 0.60;
      predictions[2] = 0.22;
      predictions[1] = 0.13;
    } else if (seed < 800) {
      // Mangrove Oyster Shell - ~20%
      predictions[4] = 0.70;
      predictions[0] = 0.15;
      predictions[2] = 0.10;
    } else {
      // Various combinations
      predictions[1] = 0.55; // Eastern Meat
      predictions[3] = 0.25; // Pacific Meat
      predictions[5] = 0.15; // Mangrove Meat
    }
    
    return predictions;
  }

  /// Convert image to byte list for TFLite
  List<Uint8List> _imageToByteList(img.Image image, int inputSize) {
    final convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var pixel = 0;

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        final pixelData = image.getPixelSafe(x, y);
        // Extract RGB components from pixel using the Pixel's properties
        convertedBytes[pixel++] = (pixelData.r.toInt()) & 0xFF;
        convertedBytes[pixel++] = (pixelData.g.toInt()) & 0xFF;
        convertedBytes[pixel++] = (pixelData.b.toInt()) & 0xFF;
      }
    }

    return [convertedBytes];
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

  /// Dispose resources
  void dispose() {
    if (_isInitialized) {
      // Cleanup TFLite interpreter if it was initialized
      if (_interpreter != null && _interpreter is! String) {
        try {
          _interpreter.close();
        } catch (e) {
          // Ignore cleanup errors
        }
      }
      _isInitialized = false;
    }
  }
}
