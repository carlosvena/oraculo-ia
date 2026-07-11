import 'package:oraculo_ia/src/features/content/data/knowledge_reader.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson_repository.dart';

final class SimulatedLessonRepository implements LessonRepository {
  const SimulatedLessonRepository({this.reader = const KnowledgeReader()});
  final KnowledgeReader reader;

  @override
  Future<Lesson> getLesson(String lessonId) async {
    final content = await reader.load();
    try {
      return content.lesson(lessonId);
    } on StateError {
      throw StateError('La lección "$lessonId" no existe en knowledge/.');
    }
  }
}
