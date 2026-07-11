import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LearningMode { essential, intensive }

enum ReviewLevel { understood, review, notUnderstood }

final class LearningState {
  factory LearningState.fromJson(Map<String, dynamic> json) => LearningState(
    currentLessonId: json['currentLessonId'] as String? ?? 'lesson-models-001',
    currentBlock: json['currentBlock'] as int? ?? 0,
    answers: (json['answers'] as Map<String, dynamic>? ?? const {}).map(
      (key, value) =>
          MapEntry(key, (value as List).map((item) => item as int?).toList()),
    ),
    completed: Set<String>.from(json['completed'] as List? ?? const []),
    studyMinutes: json['studyMinutes'] as int? ?? 0,
    masteredConcepts: Set<String>.from(
      json['masteredConcepts'] as List? ?? const [],
    ),
    reviewConcepts: Set<String>.from(
      json['reviewConcepts'] as List? ?? const [],
    ),
    favorites: Set<String>.from(json['favorites'] as List? ?? const []),
    mode: LearningMode.values.byName(json['mode'] as String? ?? 'intensive'),
    reviews: (json['reviews'] as Map<String, dynamic>? ?? const {}).map(
      (key, value) => MapEntry(key, ReviewLevel.values.byName(value as String)),
    ),
  );
  const LearningState({
    this.currentLessonId = 'lesson-models-001',
    this.currentBlock = 0,
    this.answers = const <String, List<int?>>{},
    this.completed = const <String>{},
    this.studyMinutes = 0,
    this.masteredConcepts = const <String>{},
    this.reviewConcepts = const <String>{},
    this.favorites = const <String>{},
    this.mode = LearningMode.intensive,
    this.reviews = const <String, ReviewLevel>{},
  });
  final String currentLessonId;
  final int currentBlock;
  final Map<String, List<int?>> answers;
  final Set<String> completed;
  final int studyMinutes;
  final Set<String> masteredConcepts;
  final Set<String> reviewConcepts;
  final Set<String> favorites;
  final LearningMode mode;
  final Map<String, ReviewLevel> reviews;

  Map<String, Object> toJson() => <String, Object>{
    'currentLessonId': currentLessonId,
    'currentBlock': currentBlock,
    'answers': answers,
    'completed': completed.toList(),
    'studyMinutes': studyMinutes,
    'masteredConcepts': masteredConcepts.toList(),
    'reviewConcepts': reviewConcepts.toList(),
    'favorites': favorites.toList(),
    'mode': mode.name,
    'reviews': reviews.map((key, value) => MapEntry(key, value.name)),
  };
  LearningState copyWith({
    String? currentLessonId,
    int? currentBlock,
    Map<String, List<int?>>? answers,
    Set<String>? completed,
    int? studyMinutes,
    Set<String>? masteredConcepts,
    Set<String>? reviewConcepts,
    Set<String>? favorites,
    LearningMode? mode,
    Map<String, ReviewLevel>? reviews,
  }) => LearningState(
    currentLessonId: currentLessonId ?? this.currentLessonId,
    currentBlock: currentBlock ?? this.currentBlock,
    answers: answers ?? this.answers,
    completed: completed ?? this.completed,
    studyMinutes: studyMinutes ?? this.studyMinutes,
    masteredConcepts: masteredConcepts ?? this.masteredConcepts,
    reviewConcepts: reviewConcepts ?? this.reviewConcepts,
    favorites: favorites ?? this.favorites,
    mode: mode ?? this.mode,
    reviews: reviews ?? this.reviews,
  );
}

abstract interface class LearningStateStore {
  Future<LearningState> load();
  Future<void> save(LearningState state);
}

final class SharedPreferencesLearningStateStore implements LearningStateStore {
  SharedPreferencesLearningStateStore(this.preferences);
  final SharedPreferencesAsync preferences;
  static const key = 'learning_state_v1';
  @override
  Future<LearningState> load() async {
    final raw = await preferences.getString(key);
    return raw == null
        ? const LearningState()
        : LearningState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(LearningState state) =>
      preferences.setString(key, jsonEncode(state.toJson()));
}

final learningStateStoreProvider = Provider<LearningStateStore>(
  (ref) => SharedPreferencesLearningStateStore(SharedPreferencesAsync()),
);
final learningStateProvider =
    AsyncNotifierProvider<LearningStateNotifier, LearningState>(
      LearningStateNotifier.new,
    );

final class LearningStateNotifier extends AsyncNotifier<LearningState> {
  LearningStateStore get store => ref.read(learningStateStoreProvider);
  @override
  Future<LearningState> build() => store.load();
  Future<void> _set(LearningState next) async {
    state = AsyncData(next);
    await store.save(next);
  }

  Future<void> setMode(LearningMode mode) async =>
      _set(state.requireValue.copyWith(mode: mode));
  Future<void> savePosition(
    String lessonId,
    int block,
    List<int?> answers,
  ) async {
    final current = state.requireValue;
    await _set(
      current.copyWith(
        currentLessonId: lessonId,
        currentBlock: block,
        answers: <String, List<int?>>{
          ...current.answers,
          lessonId: List<int?>.from(answers),
        },
      ),
    );
  }

  Future<void> complete(
    String lessonId,
    int minutes,
    Iterable<String> concepts,
  ) async {
    final current = state.requireValue;
    await _set(
      current.copyWith(
        completed: <String>{...current.completed, lessonId},
        studyMinutes: current.studyMinutes + minutes,
        masteredConcepts: <String>{...current.masteredConcepts, ...concepts},
        currentBlock: 0,
      ),
    );
  }

  Future<void> setReview(String lessonId, ReviewLevel level) async {
    final current = state.requireValue;
    final concepts = <String>{...current.reviewConcepts};
    if (level == ReviewLevel.understood) {
      concepts.remove(lessonId);
    } else {
      concepts.add(lessonId);
    }
    await _set(
      current.copyWith(
        reviews: <String, ReviewLevel>{...current.reviews, lessonId: level},
        reviewConcepts: concepts,
      ),
    );
  }

  Future<void> toggleFavorite(String id) async {
    final current = state.requireValue;
    final values = <String>{...current.favorites};
    values.contains(id) ? values.remove(id) : values.add(id);
    await _set(current.copyWith(favorites: values));
  }
}
