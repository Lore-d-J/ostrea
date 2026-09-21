import '../models/prediction_result.dart';

class OysterResultHandler {
  static const double confidenceThreshold = 0.80;
  static const String driedOysterReminder =
      'Kung mukhang natuyo ang laman, maaaring matagal nang patay o panis na ang talaba. Huwag itong kainin.';
  static const String _normalRecommendation =
      'Maayos ang nakitang kulay ng laman. Panatilihing malinis at maayos ang pag-iimbak. Lutuin nang mabuti bago kainin.';
  static const String _yellowishRecommendation =
      'May pagbabago sa kulay ng laman. Suriin ang amoy at kondisyon ng talaba. Kung may senyales ng pagkasira, huwag kainin.';
  static const String _greenishRecommendation =
      'May kapansin-pansing pagbabago sa kulay ng laman. Suriin ang amoy at kondisyon ng talaba. Kung may senyales ng pagkasira, huwag kainin.';
  static const String _unidentifiedRecommendation =
      'Hindi malinaw ang resulta. Kumuha ng mas malinaw na larawan at subukan muli.';

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
            'Normal ang kulay ng talaba, maayos ang hitsura at walang malinaw na pagbabago sa kulay. $driedOysterReminder\n\nKalagayan: Mabuti. $_normalRecommendation',
        condition: 'Mabuti',
        recommendation: _normalRecommendation,
      );
    }

    if (normalizedLabel.contains('yellow')) {
      return PredictionResult(
        label: 'Yellowish/Naninilaw',
        confidence: effectiveConfidence,
        description:
            'May bahagyang dilaw na kulay sa talaba. \n\nKung may kasamang mabahong amoy, maaaring patay, panis, o kontaminado ang talaba. Huwag itong kainin at suriin agad nang mabuti. $driedOysterReminder',
        message:
            'May bahagyang dilaw na kulay sa talaba. \n\nKung may mabahong amoy, maaaring patay, panis, o kontaminado ito. Huwag itong kainin. $driedOysterReminder\n\nKalagayan: Hindi Mabuti. $_yellowishRecommendation',
        condition: 'Hindi Mabuti',
        recommendation: _yellowishRecommendation,
      );
    }

    if (normalizedLabel.contains('green')) {
      return PredictionResult(
        label: 'Greenish/Luntiang kulay',
        confidence: effectiveConfidence,
        description:
            'May luntiang kulay na nakikita sa talaba. \n\nKung may kasamang mabahong amoy, maaaring patay, panis, o kontaminado ang talaba. Huwag itong kainin at suriin agad nang mabuti. $driedOysterReminder',
        message:
            'May luntiang kulay na nakikita sa talaba. \n\nKung may mabahong amoy, maaaring patay, panis, o kontaminado ito. Huwag itong kainin. $driedOysterReminder\n\nKalagayan: Hindi Mabuti. $_greenishRecommendation',
        condition: 'Hindi Mabuti',
        recommendation: _greenishRecommendation,
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
          'Hindi makilala ang kulay ng talaba. \n\nPumili ng mas maliwanag na larawan at siguraduhing makita nang malinaw ang talaba. O posibleng maraming talaba ang nasa larawan, maglagay lang ng isa sa isang pagkakataon. $driedOysterReminder\n\nKalagayan: Hindi Matukoy. $_unidentifiedRecommendation',
      condition: 'Hindi Matukoy',
      recommendation: _unidentifiedRecommendation,
    );
  }
}
