import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson_repository.dart';

final class SimulatedLessonRepository implements LessonRepository {
  const SimulatedLessonRepository();

  @override
  Future<Lesson> getLesson(String lessonId) async {
    try {
      return await KnowledgeEngine.instance.getLesson(lessonId);
    } catch (e) {
      throw StateError('La lección "$lessonId" no existe en knowledge/.');
    }
  }
}
