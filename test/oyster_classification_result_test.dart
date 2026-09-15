import 'package:flutter_test/flutter_test.dart';
import 'package:ostrea/services/oyster_result_handler.dart';

void main() {
  group('Oyster result handling', () {
    test('maps low confidence to unidentified', () {
      final result = OysterResultHandler().buildResult(
        label: 'Normal',
        confidence: 0.79,
      );

      expect(result.label, 'Unidentified/Di Matukoy');
      expect(result.confidence, 0.79);
      expect(result.message, contains('Hindi makilala'));
    });

    test('keeps exactly 80 percent confidence identified', () {
      final result = OysterResultHandler().buildResult(
        label: 'Normal',
        confidence: 0.80,
      );

      expect(result.label, 'Normal');
    });

    test('keeps an unidentified result unidentified at high confidence', () {
      final result = OysterResultHandler().buildResult(
        label: 'Unidentified',
        confidence: 0.95,
      );

      expect(result.label, 'Unidentified/Di Matukoy');
      expect(result.confidence, 0.95);
    });

    test('maps normal label to the healthy description', () {
      final result = OysterResultHandler().buildResult(
        label: 'Normal',
        confidence: 0.96,
      );

      expect(result.label, 'Normal');
      expect(result.description.toLowerCase(), contains('cream'));
      expect(result.message.toLowerCase(), contains('healthy'));
    });

    test('maps yellowish and greenish labels to the right descriptions', () {
      final yellowish = OysterResultHandler().buildResult(
        label: 'Yellowish Meat',
        confidence: 0.91,
      );
      final greenish = OysterResultHandler().buildResult(
        label: 'Greenish Meat',
        confidence: 0.91,
      );

      expect(yellowish.label, 'Yellowish');
      expect(yellowish.description.toLowerCase(), contains('yellow tint'));
      expect(greenish.label, 'Greenish');
      expect(
        greenish.description.toLowerCase(),
        contains('green or olive-green'),
      );
    });
  });
}
