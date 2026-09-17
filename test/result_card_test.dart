import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ostrea/models/prediction_result.dart';
import 'package:ostrea/utils/recommendation_helper.dart';
import 'package:ostrea/widgets/result_card.dart';

void main() {
  const recommendation = Recommendation(
    warningLevel: 'Unknown',
    message: 'Unable to determine condition.',
    badgeColor: Color(0xFF546E7A),
  );

  testWidgets('hides confidence for unidentified results', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResultCard(
            prediction: PredictionResult(
              label: 'Unidentified/Di Matukoy',
              confidence: 0.42,
              description: 'Hindi makilala ang kulay ng talaba.',
            ),
            recommendation: recommendation,
          ),
        ),
      ),
    );

    expect(find.textContaining('Kumpiyansa:'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('shows confidence for identified results', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResultCard(
            prediction: PredictionResult(
              label: 'Normal',
              confidence: 0.95,
              description: 'Normal ang kulay ng talaba.',
            ),
            recommendation: recommendation,
          ),
        ),
      ),
    );

    expect(find.text('Kumpiyansa: 95.0%'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
