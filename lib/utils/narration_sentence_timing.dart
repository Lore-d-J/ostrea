class NarrationSentenceRange {
  final int start;
  final int end;

  const NarrationSentenceRange(this.start, this.end);

  int get length => end - start;
}

class NarrationSectionTimeline {
  final String transcript;
  final List<int> sectionOffsets;

  const NarrationSectionTimeline({
    required this.transcript,
    required this.sectionOffsets,
  });
}

NarrationSectionTimeline buildTroubleshootingNarrationTimeline({
  required String title,
  required String problem,
  required String cause,
  required List<String> solutions,
}) {
  final sourceSections = [title, problem, cause];
  final sourceOffsets = <int>[];
  var sourceSentenceCount = 0;
  for (final section in sourceSections) {
    sourceOffsets.add(sourceSentenceCount);
    sourceSentenceCount += narrationSentenceRanges(section).length;
  }

  final additionalSections = <String>[];
  final solutionOffsets = <int>[];
  var additionalSentenceCount = 0;
  for (final solution in solutions) {
    final sourceIndex = sourceSections.indexOf(solution);
    if (sourceIndex >= 0) {
      solutionOffsets.add(sourceOffsets[sourceIndex]);
    } else {
      solutionOffsets.add(sourceSentenceCount + additionalSentenceCount);
      additionalSections.add(solution);
      additionalSentenceCount += narrationSentenceRanges(solution).length;
    }
  }

  return NarrationSectionTimeline(
    transcript: [...sourceSections, ...additionalSections].join('\n'),
    sectionOffsets: solutionOffsets,
  );
}

List<NarrationSentenceRange> narrationSentenceRanges(String text) {
  final ranges = <NarrationSentenceRange>[];
  final sentencePattern = RegExp(r'[^.!?\n]+[.!?]*');

  for (final match in sentencePattern.allMatches(text)) {
    var start = match.start;
    var end = match.end;
    while (start < end && text[start].trim().isEmpty) {
      start++;
    }
    while (end > start && text[end - 1].trim().isEmpty) {
      end--;
    }
    if (start < end) ranges.add(NarrationSentenceRange(start, end));
  }

  return ranges;
}

int? narrationSentenceAtPosition(
  String text,
  Duration position,
  Duration? duration,
) {
  final ranges = narrationSentenceRanges(text);
  if (ranges.isEmpty || duration == null || duration.inMicroseconds <= 0) {
    return null;
  }

  final elapsed = position.inMicroseconds;
  if (elapsed >= duration.inMicroseconds) return null;

  final totalWeight = ranges.fold<int>(0, (sum, range) => sum + range.length);
  final elapsedWeight =
      totalWeight * elapsed / duration.inMicroseconds;
  var cumulativeWeight = 0;
  for (var index = 0; index < ranges.length; index++) {
    cumulativeWeight += ranges[index].length;
    if (elapsedWeight < cumulativeWeight) return index;
  }
  return ranges.length - 1;
}