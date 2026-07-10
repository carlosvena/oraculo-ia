import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson_repository.dart';

final class GetLesson {
  const GetLesson(this._repository);

  final LessonRepository _repository;

  Future<Lesson> call(String lessonId) => _repository.getLesson(lessonId);
}
