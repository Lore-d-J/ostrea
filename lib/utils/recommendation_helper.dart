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
    case 'Black Spots':
      return const Recommendation(
        warningLevel: 'Warning',
        message:
            'Possible shell damage or disease detected. Further inspection is recommended.',
        badgeColor: Color(0xFFD32F2F),
      );
    case 'Damaged/Open Shell':
      return const Recommendation(
        warningLevel: 'Unsafe',
        message:
            'The oyster may already be dead or unsafe. Remove immediately.',
        badgeColor: Color(0xFFB71C1C),
      );
    default:
      return const Recommendation(
        warningLevel: 'Unknown',
        message: 'Unable to determine condition. Review the oyster manually.',
        badgeColor: Color(0xFF546E7A),
      );
  }
}
