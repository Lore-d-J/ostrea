import '../models/prediction_result.dart';

class OysterResultHandler {
  static const double confidenceThreshold = 0.80;
  static const String driedOysterReminder =
      'Kung mukhang natuyo ang laman, maaaring matagal nang patay o panis na ang talaba. Huwag itong kainin.';

  PredictionResult buildResult({
    required String label,
    required double confidence,
  }) {
    final normalizedLabel = label.trim().toLowerCase();
    final effectiveConfidence = confidence.clamp(0.0, 1.0);

    if (normalizedLabel.contains('unidentified') ||
        normalizedLabel.contains('di matukoy')) {
      return _buildUnidentifiedResult(effectiveConfidence);
    }

    if (effectiveConfidence < confidenceThreshold) {
      return _buildUnidentifiedResult(effectiveConfidence);
    }

    if (normalizedLabel.contains('normal')) {
      return PredictionResult(
        label: 'Normal',
        confidence: effectiveConfidence,
        description:
            'Normal ang kulay ng talaba, maayos ang hitsura at walang malinaw na pagbabago sa kulay. $driedOysterReminder',
        message:
            'Normal ang kulay ng talaba, maayos ang hitsura at walang malinaw na pagbabago sa kulay. $driedOysterReminder',
      );
    }

    if (normalizedLabel.contains('yellow')) {
      return PredictionResult(
        label: 'Yellowish/Naninilaw',
        confidence: effectiveConfidence,
        description:
            'May bahagyang dilaw na kulay sa talaba. \n\nKung may kasamang mabahong amoy, maaaring patay, panis, o kontaminado ang talaba. Huwag itong kainin at suriin agad nang mabuti. $driedOysterReminder',
        message:
            'May bahagyang dilaw na kulay sa talaba. \n\nKung may mabahong amoy, maaaring patay, panis, o kontaminado ito. Huwag itong kainin. $driedOysterReminder',
      );
    }

    if (normalizedLabel.contains('green')) {
      return PredictionResult(
        label: 'Greenish/Luntiang kulay',
        confidence: effectiveConfidence,
        description:
            'May luntiang kulay na nakikita sa talaba. \n\nKung may kasamang mabahong amoy, maaaring patay, panis, o kontaminado ang talaba. Huwag itong kainin at suriin agad nang mabuti. $driedOysterReminder',
        message:
            'May luntiang kulay na nakikita sa talaba. \n\nKung may mabahong amoy, maaaring patay, panis, o kontaminado ito. Huwag itong kainin. $driedOysterReminder',
      );
    }

    return _buildUnidentifiedResult(effectiveConfidence);
  }

  PredictionResult _buildUnidentifiedResult(double confidence) {
    return PredictionResult(
      label: 'Unidentified/Di Matukoy',
      confidence: confidence,
      description:
          'Hindi makilala ang kulay ng talaba. \n\nPumili ng mas maliwanag na larawan at siguraduhing makita nang malinaw ang talaba. O posibleng maraming talaba ang nasa larawan, maglagay lang ng isa sa isang pagkakataon. $driedOysterReminder',
      message:
          'Hindi makilala ang kulay ng talaba. \n\nPumili ng mas maliwanag na larawan at siguraduhing makita nang malinaw ang talaba. O posibleng maraming talaba ang nasa larawan, maglagay lang ng isa sa isang pagkakataon. $driedOysterReminder',
    );
  }
}
