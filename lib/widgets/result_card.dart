import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../services/audio_playback_service.dart';
import '../utils/recommendation_helper.dart';
import 'audio_narration_button.dart';
import 'audio_narration_text.dart';

class ResultCard extends StatefulWidget {
  final PredictionResult prediction;
  final Recommendation recommendation;

  const ResultCard({
    super.key,
    required this.prediction,
    required this.recommendation,
  });

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  final AudioPlaybackService _audioService = AudioPlaybackService();

  String _resultKey(String label) => label
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');

  @override
  void dispose() {
    if (_audioService.activeAudioId?.startsWith('result:') ?? false) {
      _audioService.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prediction = widget.prediction;
    final recommendation = widget.recommendation;
    final resultKey = _resultKey(prediction.label);
    final normalizedLabel = prediction.label.toLowerCase();
    final isUnidentified =
        normalizedLabel.contains('unidentified') ||
        normalizedLabel.contains('di matukoy');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Klase ng Resulta',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: recommendation.badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendation.warningLevel,
                  style: TextStyle(
                    color: recommendation.badgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prediction.label,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: recommendation.badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: recommendation.badgeColor.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              'Kalagayan: ${prediction.condition}',
              style: TextStyle(
                color: recommendation.badgeColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Paglalarawan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AudioNarrationButton(
                audioId: 'result:$resultKey:paglalarawan',
                assetPath:
                    'assets/audio/results/${resultKey}_paglalarawan.mp3',
                tooltip: 'Pakinggan ang Paglalarawan',
              ),
            ],
          ),
          AudioNarrationText(
            audioId: 'result:$resultKey:paglalarawan',
            text: prediction.description.isNotEmpty
                ? prediction.description
                : recommendation.message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Payo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AudioNarrationButton(
                audioId: 'result:$resultKey:payo',
                assetPath: 'assets/audio/results/${resultKey}_payo.mp3',
                tooltip: 'Pakinggan ang Payo',
              ),
            ],
          ),
          AudioNarrationText(
            audioId: 'result:$resultKey:payo',
            text: prediction.recommendation.isNotEmpty
                ? prediction.recommendation
                : recommendation.message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          if (!isUnidentified) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: prediction.confidence,
              color: recommendation.badgeColor,
              backgroundColor: recommendation.badgeColor.withValues(
                alpha: 0.15,
              ),
              minHeight: 8,
            ),
          ],
        ],
      ),
    );
  }
}
