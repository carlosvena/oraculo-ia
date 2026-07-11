import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

void main() {
  test('restores exact progress after a simulated restart', () async {
    final store = _MemoryStore();
    const expected = LearningState(
      currentLessonId: 'lesson-context-004',
      currentBlock: 7,
      answers: <String, List<int?>>{
        'lesson-context-004': <int?>[0, 1, 2],
      },
      completed: <String>{
        'lesson-models-001',
        'lesson-prompts-002',
        'lesson-llm-003',
      },
      studyMinutes: 100,
      masteredConcepts: <String>{'LLM'},
      mode: LearningMode.intensive,
    );
    await store.save(expected);
    final restored = await store.load();
    expect(restored.currentLessonId, expected.currentLessonId);
    expect(restored.currentBlock, 7);
    expect(restored.answers['lesson-context-004'], <int?>[0, 1, 2]);
    expect(restored.completed, expected.completed);
    expect(restored.studyMinutes, 100);
  });

  test('persists intensive mode, review and favorites in JSON', () {
    const state = LearningState(
      mode: LearningMode.intensive,
      reviews: <String, ReviewLevel>{'lesson-llm-003': ReviewLevel.review},
      favorites: <String>{'term:llm'},
    );
    final restored = LearningState.fromJson(state.toJson());
    expect(restored.mode, LearningMode.intensive);
    expect(restored.reviews['lesson-llm-003'], ReviewLevel.review);
    expect(restored.favorites, contains('term:llm'));
  });

  test('sequential mission completion can unlock only the next mission', () {
    const ids = <String>[
      'lesson-models-001',
      'lesson-prompts-002',
      'lesson-llm-003',
      'lesson-context-004',
      'lesson-prompts-005',
    ];
    const completed = <String>{'lesson-models-001', 'lesson-prompts-002'};
    final unlocked = <String>[
      for (var i = 0; i < ids.length; i++)
        if (i == 0 || completed.contains(ids[i - 1])) ids[i],
    ];
    expect(unlocked, <String>[
      'lesson-models-001',
      'lesson-prompts-002',
      'lesson-llm-003',
    ]);
  });
}

final class _MemoryStore implements LearningStateStore {
  LearningState value = const LearningState();

  @override
  Future<LearningState> load() async => LearningState.fromJson(value.toJson());

  @override
  Future<void> save(LearningState state) async {
    value = state;
  }
}
