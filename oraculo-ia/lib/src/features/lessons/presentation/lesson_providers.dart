import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/lessons/domain/get_lesson.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson_repository.dart';

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  throw UnimplementedError('Debe configurarse durante bootstrap.');
});

final getLessonProvider = Provider<GetLesson>((ref) {
  return GetLesson(ref.watch(lessonRepositoryProvider));
});

final lessonProvider = FutureProvider.family<Lesson, String>((ref, lessonId) {
  return ref.watch(getLessonProvider)(lessonId);
});
