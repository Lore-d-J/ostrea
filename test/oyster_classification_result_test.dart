import 'package:flutter_test/flutter_test.dart';
import 'package:ostrea/services/oyster_result_handler.dart';

void main() {
  group('Oyster result handling', () {
    test('maps low confidence to unidentified', () {
      final result = OysterResultHandler().buildResult(
        label: 'Normal',
        confidence: 0.65,
      );

      expect(result.label, 'Unidentified');
      expect(result.confidence, 0.65);
      expect(result.message, contains('clearer image'));
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
      expect(greenish.description.toLowerCase(), contains('green or olive-green'));
    });
  });
}
