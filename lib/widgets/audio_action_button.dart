import 'package:flutter/material.dart';

class AudioActionButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;
  final String playingLabel;
  final String stoppedLabel;
  final Color activeColor;
  final Color inactiveColor;
  final IconData playingIcon;
  final IconData stoppedIcon;
  final double iconSize;

  const AudioActionButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
    required this.playingLabel,
    required this.stoppedLabel,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.green,
    this.playingIcon = Icons.stop,
    this.stoppedIcon = Icons.volume_up,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = isPlaying ? activeColor : inactiveColor;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            isPlaying ? playingIcon : stoppedIcon,
            size: iconSize,
          ),
          if (isPlaying)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                key: const ValueKey('audio_playing_indicator'),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: activeColor, width: 1.5),
                ),
              ),
            ),
        ],
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isPlaying ? playingLabel : stoppedLabel),
          if (isPlaying) ...[
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 18,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white.withOpacity(0.9),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _soundBar(0.45),
                  _soundBar(0.75),
                  _soundBar(1.0),
                ],
              ),
            ),
          ],
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: isPlaying ? 4 : 2,
      ),
    );
  }

  Widget _soundBar(double scale) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 3,
      height: 3 + (scale * 3),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }
}
