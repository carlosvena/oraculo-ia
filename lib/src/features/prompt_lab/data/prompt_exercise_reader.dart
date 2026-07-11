import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:oraculo_ia/src/features/prompt_lab/domain/prompt_exercise.dart';

final class PromptExerciseReader {
  const PromptExerciseReader();
  Future<List<PromptExercise>> load() =>
      rootBundle.loadString('knowledge/prompt_exercises_v1.json').then(parse);
  List<PromptExercise> parse(String source) {
    final root = jsonDecode(source) as Map<String, dynamic>;
    if (root['schemaVersion'] != 1) {
      throw const FormatException('Esquema incompatible');
    }
    return (root['exercises'] as List)
        .cast<Map<String, dynamic>>()
        .map(
          (e) => PromptExercise(
            id: e['id'] as String,
            category: e['category'] as String,
            level: e['level'] as int,
            title: e['title'] as String,
            original: e['original'] as String,
            improved: e['improved'] as String,
            why: e['why'] as String,
          ),
        )
        .toList();
  }
}
