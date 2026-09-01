import 'package:flutter/material.dart';

class Recommendation {
  final String warningLevel;
  final String message;
  final Color badgeColor;

  const Recommendation({
    required this.warningLevel,
    required this.message,
    required this.badgeColor,
  });
}

Recommendation getRecommendation(String label) {
  switch (label) {
    case 'Healthy Oyster':
      return const Recommendation(
        warningLevel: 'Safe',
        message: 'The oyster appears healthy and suitable for monitoring.',
        badgeColor: Color(0xFF2E7D32),
      );
    case 'Slight Yellow Discoloration':
      return const Recommendation(
        warningLevel: 'Monitor',
        message:
            'Possible spoilage or poor water quality detected. Observe closely and inspect manually.',
        badgeColor: Color(0xFFF9A825),
      );
    case 'Dark/Brown Discoloration':
      return const Recommendation(
        warningLevel: 'Warning',
        message:
            'Potential contamination or unhealthy condition detected. Separate from healthy oysters.',
        badgeColor: Color(0xFFF57F17),
      );
    case 'Nothing':
      return const Recommendation(
        warningLevel: 'N/A',
        message: 'No oyster detected in the image. Please ensure the oyster is clearly visible in the frame.',
        badgeColor: Color(0xFF9E9E9E),
      );
    default:
      return const Recommendation(
        warningLevel: 'Unknown',
        message: 'Unable to determine condition. Review the oyster manually.',
        badgeColor: Color(0xFF546E7A),
      );
  }
}
