import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../models/prediction_result.dart';

class ImageClassifierService {
  static const modelAssetPath = 'assets/model/model.tflite';
  static const labelsAssetPath = 'assets/model/labels.txt';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await Future.delayed(const Duration(milliseconds: 250));
    _initialized = true;
  }

  /// Returns a mock prediction for the selected image.
  ///
  /// Replace this method with TensorFlow Lite inference when the model is ready.
  Future<PredictionResult> classifyImage(Uint8List imageBytes) async {
    if (!_initialized) {
      await initialize();
    }

    await Future.delayed(const Duration(seconds: 2));

    return PredictionResult(
      label: 'Slight Yellow Discoloration',
      confidence: 0.84,
    );
  }

  Future<bool> modelAssetsAvailable() async {
    try {
      await rootBundle.load(modelAssetPath);
      await rootBundle.loadString(labelsAssetPath);
      return true;
    } catch (_) {
      return false;
    }
  }
}
