import 'dart:typed_data';

abstract class DiseaseIdentificationInterface {
  Future<void> initialize();
  Future<Map<String, dynamic>> identifyDisease(Uint8List imageBytes);
  void dispose();
}