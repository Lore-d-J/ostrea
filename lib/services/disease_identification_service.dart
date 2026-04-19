import 'dart:typed_data';
import 'disease_identification_interface.dart';
import 'disease_identification_web.dart';

class DiseaseIdentificationService implements DiseaseIdentificationInterface {
  late DiseaseIdentificationInterface _impl;
  bool _isInitialized = false;

  final List<String> diseaseLabels = [
    'Healthy Oyster',
    'Diseased Oyster (Perkinsus)',
    'Diseased Oyster (Bonamia)',
    'Diseased Oyster (MSX)',
    'Barnacles',
    'Unknown',
  ];

  /// Initialize the service
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Always use web implementation for now (since TFLite doesn't work on web)
    _impl = DiseaseIdentificationWeb();
    await _impl.initialize();
    _isInitialized = true;
  }

  /// Identify oyster disease from image bytes
  @override
  Future<Map<String, dynamic>> identifyDisease(Uint8List imageBytes) async {
    if (!_isInitialized) {
      await initialize();
    }
    return _impl.identifyDisease(imageBytes);
  }

  /// Dispose resources
  @override
  void dispose() {
    if (_isInitialized) {
      _impl.dispose();
      _isInitialized = false;
    }
  }
}
