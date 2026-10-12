import 'package:flutter_test/flutter_test.dart';
import 'package:ostrea/utils/narration_sentence_timing.dart';

void main() {
  test('splits transcript into sentence and paragraph ranges', () {
    final ranges = narrationSentenceRanges('Una. Ikalawa!\nHuli?');

    expect(ranges, hasLength(3));
    expect('Una. Ikalawa!\nHuli?'.substring(ranges[0].start, ranges[0].end), 'Una.');
    expect(
      'Una. Ikalawa!\nHuli?'.substring(ranges[1].start, ranges[1].end),
      'Ikalawa!',
    );
    expect('Una. Ikalawa!\nHuli?'.substring(ranges[2].start, ranges[2].end), 'Huli?');
  });

  test('maps playback position to length-weighted sentence timing', () {
    const transcript = 'Una. Ikalawa!';
    const duration = Duration(milliseconds: 1200);

    expect(
      narrationSentenceAtPosition(
        transcript,
        const Duration(milliseconds: 300),
        duration,
      ),
      0,
    );
    expect(
      narrationSentenceAtPosition(
        transcript,
        const Duration(milliseconds: 500),
        duration,
      ),
      1,
    );
    expect(
      narrationSentenceAtPosition(transcript, duration, duration),
      isNull,
    );
  });

  test('does not estimate a sentence without a known duration', () {
    expect(
      narrationSentenceAtPosition('Walang tagal.', Duration.zero, null),
      isNull,
    );
  });

  test('maps repeated troubleshooting solutions to their first narration', () {
    final timeline = buildTroubleshootingNarrationTimeline(
      title: 'Nasira ang istruktura',
      problem: 'Suriin ang kawayan, poste, lubid, at platform.',
      cause: 'Ayusin o palitan agad ang sirang bahagi.',
      solutions: [
        'Suriin ang kawayan, poste, lubid, at platform.',
        'Ayusin o palitan agad ang sirang bahagi.',
      ],
    );

    expect(timeline.sectionOffsets, [1, 2]);
    expect(narrationSentenceRanges(timeline.transcript), hasLength(3));
  });

  test('places distinct troubleshooting advice after narrated problem and cause', () {
    final timeline = buildTroubleshootingNarrationTimeline(
      title: 'Malakas ang alon o hangin',
      problem: 'Suriin ang mga poste at nakasabit na pamitan.',
      cause: 'Ayusin ang anumang nasira.',
      solutions: [
        'Suriin ang mga poste at nakasabit na pamitan.',
        'Ayusin ang anumang nasira.',
        'Pumili ng lugar na protektado laban sa alon.',
      ],
    );

    expect(timeline.sectionOffsets, [1, 2, 3]);
    expect(narrationSentenceRanges(timeline.transcript), hasLength(4));
  });
}