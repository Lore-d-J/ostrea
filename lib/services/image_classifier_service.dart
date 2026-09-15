import 'dart:typed_data';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/prediction_result.dart';
import 'image_preprocessor.dart';
import 'oyster_result_handler.dart';

class ImageClassifierService {
  static const modelAssetPath = 'assets/models/model_unquant.tflite';
  static const labelsAssetPath = 'assets/models/labels.txt';

  final ImagePreprocessor _preprocessor = const ImagePreprocessor();
  final OysterResultHandler _resultHandler = OysterResultHandler();

  bool _initialized = false;
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _interpreter = await Interpreter.fromAsset(modelAssetPath);

      final labelsText = await rootBundle.loadString(labelsAssetPath);
      _labels = labelsText
          .split('\n')
          .where((s) => s.trim().isNotEmpty)
          .map((s) => s.replaceFirst(RegExp(r'^\d+[.\s]+'), '').trim())
          .toList();

      _initialized = true;
    } catch (e) {
      debugPrint('Failed to initialize ImageClassifierService: $e');
    }
  }

  static bool looksGreenish(Uint8List imageBytes) {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return false;

      final resized = img.copyResize(image, width: 48, height: 48);
      int greenPixels = 0;
      int sampledPixels = 0;

      for (int y = 0; y < resized.height; y++) {
        for (int x = 0; x < resized.width; x++) {
          final pixel = resized.getPixel(x, y);
          final avg = (pixel.r + pixel.g + pixel.b) / 3;
          if (avg < 230 && pixel.g > pixel.r && pixel.g > pixel.b) {
            greenPixels++;
          }
          sampledPixels++;
        }
      }

      if (sampledPixels == 0) return false;
      return (greenPixels / sampledPixels) > 0.025;
    } catch (_) {
      return false;
    }
  }

  Future<PredictionResult> classifyImage(Uint8List imageBytes) async {
    if (!_initialized) {
      await initialize();
    }

    if (_interpreter == null || _labels == null) {
      throw Exception('Classifier not initialized. Check if model and labels exist.');
    }

    final inputBuffer = _preprocessor.preprocess(imageBytes);
    final input = inputBuffer.reshape([1, 224, 224, 3]);

    final numLabels = _labels!.length;
    final output = List.filled(1 * numLabels, 0.0).reshape([1, numLabels]);

    _interpreter!.run(input, output);

    double maxConfidence = -1.0;
    int maxIndex = 0;
    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > maxConfidence) {
        maxConfidence = output[0][i];
        maxIndex = i;
      }
    }

    final rawLabel = _labels![maxIndex];
    final greenishDetected = looksGreenish(imageBytes);
    final label = greenishDetected && rawLabel.toLowerCase().contains('normal')
        ? 'Greenish Meat'
        : rawLabel;

    final confidence = greenishDetected && maxConfidence < 0.70
        ? 0.70
        : maxConfidence;

    return _resultHandler.buildResult(
      label: label,
      confidence: confidence,
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
