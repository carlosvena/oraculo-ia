import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

abstract interface class LessonRepository {
  Future<Lesson> getLesson(String lessonId);
}
