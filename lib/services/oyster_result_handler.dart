import '../models/prediction_result.dart';

class OysterResultHandler {
  static const double confidenceThreshold = 0.70;

  PredictionResult buildResult({required String label, required double confidence}) {
    final normalizedLabel = label.trim().toLowerCase();
    final effectiveConfidence = confidence.clamp(0.0, 1.0);

    if (effectiveConfidence < confidenceThreshold) {
      return PredictionResult(
        label: 'Unidentified/Di Matukoy',
        confidence: effectiveConfidence,
        description: 'Hindi makilala ang talaba. Pumili ng mas maliwanag na larawan at siguraduhing makita nang malinaw ang talaba. O posibleng maraming talaba ang nasa larawan, maglagay lang ng isa sa isang pagkakataon.',
        message: 'Hindi makilala ang talaba. Pumili ng mas maliwanag na larawan at siguraduhing makita nang malinaw ang talaba. O posibleng maraming talaba ang nasa larawan, maglagay lang ng isa sa isang pagkakataon.',
      );
    }

    if (normalizedLabel.contains('normal')) {
      return PredictionResult(
        label: 'Normal',
        confidence: effectiveConfidence,
        description: 'Normal ang kulay ng talaba, maayos ang hitsura at walang malinaw na pagbabago sa kulay.',
        message: 'Normal ang kulay ng talaba, maayos ang hitsura at walang malinaw na pagbabago sa kulay.',
      );
    }

    if (normalizedLabel.contains('yellow')) {
      return PredictionResult(
        label: 'Yellowish/Naninilaw',
        confidence: effectiveConfidence,
        description: 'May bahagyang dilaw na kulay sa talaba, pero hindi pa ganap na may abnormal na hitsura.',
        message: 'May bahagyang dilaw na kulay sa talaba. Dapat itong bantayan at suriin ng mabuti.',
      );
    }

    if (normalizedLabel.contains('green')) {
      return PredictionResult(
        label: 'Greenish/Luntiang kulay',
        confidence: effectiveConfidence,
        description: 'May luntiang kulay na nakikita sa talaba, na maaaring senyales ng hindi maayos na kondisyon.',
        message: 'May luntiang kulay na nakikita sa talaba. Dapat itong maingat na i-monitor at ayusin ang kondisyon ng tubig.',
      );
    }

    return PredictionResult(
      label: 'Unidentified/Di Matukoy',
      confidence: effectiveConfidence,
      description: 'Hindi makilala ang kulay ng talaba. Pumili ng mas maliwanag na larawan at siguraduhing makita nang malinaw ang talaba. O posibleng maraming talaba ang nasa larawan, maglagay lang ng isa sa isang pagkakataon.',
      message: 'Hindi makilala ang kulay ng talaba. Pumili ng mas maliwanag na larawan at siguraduhing makita nang malinaw ang talaba. O posibleng maraming talaba ang nasa larawan, maglagay lang ng isa sa isang pagkakataon.',
    );
  }
}
