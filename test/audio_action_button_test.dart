import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ostrea/widgets/audio_action_button.dart';

void main() {
  testWidgets('uses red while playing and green when stopped by default', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AudioActionButton(
                isPlaying: true,
                playingLabel: 'Playing',
                stoppedLabel: 'Listen',
                onPressed: () {},
              ),
              AudioActionButton(
                isPlaying: false,
                playingLabel: 'Playing',
                stoppedLabel: 'Listen',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    final playingButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton).first);
    final stoppedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton).last);

    expect(find.text('Playing'), findsOneWidget);
    expect(find.text('Listen'), findsOneWidget);
    expect(find.byKey(const ValueKey('audio_playing_indicator')), findsOneWidget);
    expect(playingButton.style?.backgroundColor?.resolve({}), Colors.red);
    expect(stoppedButton.style?.backgroundColor?.resolve({}), Colors.green);
  });
}
