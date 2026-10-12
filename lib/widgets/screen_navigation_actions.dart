import 'package:flutter/material.dart';
import 'package:ostrea/screens/about_us_screen.dart';
import 'package:ostrea/screens/dictionary_screen.dart';
import 'package:ostrea/screens/help_screen.dart';
import 'package:ostrea/services/audio_playback_service.dart';

class HelpTooltipState {
  static bool hasShown = false;
}

class ScreenNavigationActions extends StatelessWidget {
  final LayerLink? helpLayerLink;
  final VoidCallback? onHelpPressed;
  final double verticalOffset;

  const ScreenNavigationActions({
    super.key,
    this.helpLayerLink,
    this.onHelpPressed,
    this.verticalOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final helpButton = IconButton(
      icon: const Icon(Icons.help_outline, color: Colors.white),
      tooltip: 'Help',
      onPressed:
          () async {
            await AudioPlaybackService().stop();
            if (!context.mounted) return;
            if (onHelpPressed != null) {
              onHelpPressed!();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LegacyHelpScreen(),
                ),
              );
            }
          },
    );

    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.auto_stories, color: Colors.white),
            tooltip: 'Diksyonaryo',
            onPressed: () async {
              await AudioPlaybackService().stop();
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DictionaryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'About Us',
            onPressed: () async {
              await AudioPlaybackService().stop();
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: helpLayerLink == null
                ? helpButton
                : CompositedTransformTarget(
                    link: helpLayerLink!,
                    child: helpButton,
                  ),
          ),
        ],
      ),
    );
  }
}
