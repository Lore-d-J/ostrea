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
      expect(result.condition, 'Hindi Matukoy');
      expect(result.recommendation, contains('Hindi malinaw ang resulta'));
    });

    test('keeps exactly 80 percent confidence identified', () {
      final result = OysterResultHandler().buildResult(
        label: 'Normal',
        confidence: 0.80,
      );

      expect(result.label, 'Normal');
      expect(result.condition, 'Mabuti');
    });

    test('keeps an unidentified result unidentified at high confidence', () {
      final result = OysterResultHandler().buildResult(
        label: 'Unidentified',
        confidence: 0.95,
      );

      expect(result.label, 'Unidentified/Di Matukoy');
      expect(result.confidence, 0.95);
      expect(result.condition, 'Hindi Matukoy');
    });

    test('maps normal label to the healthy description', () {
      final result = OysterResultHandler().buildResult(
        label: 'Normal',
        confidence: 0.96,
      );

      expect(result.label, 'Normal');
      expect(result.description, contains('Normal ang kulay'));
      expect(result.condition, 'Mabuti');
      expect(result.recommendation, contains('Lutuin nang mabuti'));
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

      expect(yellowish.label, 'Yellowish/Naninilaw');
      expect(yellowish.condition, 'Hindi Mabuti');
      expect(yellowish.recommendation, contains('May pagbabago sa kulay'));
      expect(greenish.label, 'Greenish/Luntiang kulay');
      expect(greenish.condition, 'Hindi Mabuti');
      expect(
        greenish.recommendation,
        contains('May kapansin-pansing pagbabago'),
      );
    });
  });
}
