import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/prompt_lab/data/prompt_exercise_reader.dart';
import 'package:oraculo_ia/src/features/prompt_lab/domain/prompt_exercise.dart';

void main() {
  test('loads twenty exercises across seven categories', () async {
    final items = const PromptExerciseReader().parse(
      await File('knowledge/prompt_exercises_v1.json').readAsString(),
    );
    expect(items, hasLength(20));
    expect(items.map((e) => e.category).toSet(), hasLength(7));
  });
  test('editorial rules explain why a prompt improves', () {
    final weak = PromptRules.evaluate('Resumí esto');
    final strong = PromptRules.evaluate(
      'Para dirección, entregá cinco puntos con evidencia y no inventes datos.',
    );
    expect(strong.score, greaterThan(weak.score));
    expect(strong.feedback, hasLength(5));
  });
}
