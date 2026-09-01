import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
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
    return _resultHandler.buildResult(
      label: rawLabel,
      confidence: maxConfidence,
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
