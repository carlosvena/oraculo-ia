import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson_repository.dart';

final class SimulatedLessonRepository implements LessonRepository {
  const SimulatedLessonRepository();

  @override
  Future<Lesson> getLesson(String lessonId) async {
    if (lessonId != 'lesson-models-001') {
      throw StateError('La lección no existe.');
    }
    return Lesson(
      id: lessonId,
      contentVersion: 1,
      title: 'Qué es un modelo de Inteligencia Artificial',
      objective:
          'Entender qué hace un modelo de IA y reconocerlo en ejemplos cotidianos.',
      blocks: const <LessonBlock>[
        LessonBlock(
          type: LessonBlockType.context,
          content:
              '[TEMPORAL] Los modelos están detrás de asistentes, recomendaciones, filtros y herramientas profesionales. Entenderlos permite evaluar sus posibilidades y límites.',
          sequence: 1,
        ),
        LessonBlock(
          type: LessonBlockType.concept,
          content:
              '[TEMPORAL] Un modelo de IA aprende relaciones estadísticas a partir de datos y las utiliza para generar, clasificar o predecir resultados ante información nueva.',
          sequence: 2,
        ),
        LessonBlock(
          type: LessonBlockType.examples,
          content:
              '[TEMPORAL] Tres aplicaciones reales para reconocer el concepto:',
          items: <String>[
            'Un filtro de correo clasifica mensajes como spam o válidos.',
            'Un asistente genera una respuesta a partir de instrucciones y contexto.',
            'Un sistema de recomendación ordena contenido según patrones de uso.',
          ],
          sequence: 3,
        ),
        LessonBlock(
          type: LessonBlockType.laboratory,
          content:
              '[TEMPORAL] Aplicá el concepto eligiendo los datos adecuados para una tarea concreta.',
          prompt: 'Completá la actividad interactiva antes de continuar.',
          sequence: 4,
        ),
        LessonBlock(
          type: LessonBlockType.challenge,
          content:
              '[TEMPORAL] Una empresa quiere automatizar soporte, pero sólo posee diez conversaciones antiguas y contradictorias.',
          prompt:
              '¿Qué riesgos identificarías antes de elegir o entrenar un modelo?',
          sequence: 5,
        ),
        LessonBlock(
          type: LessonBlockType.debate,
          content:
              '[TEMPORAL] Compará dos perspectivas sobre el mismo problema:',
          items: <String>[
            'Automatizar primero permite aprender rápidamente mediante uso real.',
            'Evaluar primero reduce errores, riesgos y falsas expectativas.',
          ],
          sequence: 6,
        ),
        LessonBlock(
          type: LessonBlockType.tools,
          content:
              '[TEMPORAL] Distintos modelos pueden resolver la tarea con fortalezas, límites y costos diferentes.',
          items: <String>[
            'ChatGPT: conversación, análisis y herramientas integradas.',
            'Gemini: contexto multimodal e integración con Google.',
            'Claude: trabajo con documentos y respuestas extensas.',
            'DeepSeek, Qwen y GLM: alternativas con distintos modelos y despliegues.',
          ],
          sequence: 7,
        ),
        LessonBlock(
          type: LessonBlockType.commonMistake,
          content:
              '[TEMPORAL] El error más común es tratar la respuesta del modelo como verdad garantizada. Un modelo produce resultados plausibles que deben evaluarse.',
          sequence: 8,
        ),
        LessonBlock(
          type: LessonBlockType.miniAssessment,
          content:
              '[TEMPORAL] Comprobá los conceptos esenciales de esta misión.',
          sequence: 9,
        ),
        LessonBlock(
          type: LessonBlockType.executiveSummary,
          content:
              '[TEMPORAL] Un modelo aprende patrones, los aplica a información nueva y debe elegirse y evaluarse según la tarea, los datos y el riesgo.',
          sequence: 10,
        ),
        LessonBlock(
          type: LessonBlockType.nextStep,
          content:
              '[TEMPORAL] En la próxima misión aprenderás a formular instrucciones claras y criterios para evaluar una respuesta.',
          prompt: 'Completá la misión para registrar tu avance simulado.',
          sequence: 11,
        ),
      ],
    );
  }
}
