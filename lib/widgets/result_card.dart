import 'package:flutter/material.dart';
import '../models/prediction_result.dart';
import '../utils/recommendation_helper.dart';

class ResultCard extends StatelessWidget {
  final PredictionResult prediction;
  final Recommendation recommendation;

  const ResultCard({
    super.key,
    required this.prediction,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kumpiyansa: ${prediction.confidencePercentage}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Paglalarawan: ${prediction.description.isNotEmpty ? prediction.description : recommendation.message}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: prediction.confidence,
            color: recommendation.badgeColor,
            backgroundColor: recommendation.badgeColor.withValues(alpha: 0.15),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
