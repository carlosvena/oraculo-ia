import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

void main() {
  test('backup preview data roundtrips before confirmation', () {
    const original = LearningState(
      completed: {'lesson-models-001'},
      studyMinutes: 45,
      currentBlock: 3,
    );
    final preview = LearningState.fromJson(
      jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
    );
    expect(preview.completed, hasLength(1));
    expect(preview.studyMinutes, 45);
    expect(preview.currentBlock, 3);
  });
}
