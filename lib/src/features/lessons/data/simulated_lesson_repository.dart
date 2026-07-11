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
      contentVersion: 2,
      title: 'Qué es realmente un modelo de IA',
      objective:
          'Comprender cómo aprende un modelo, qué puede hacer y por qué sus respuestas necesitan criterio humano.',
      blocks: const <LessonBlock>[
        LessonBlock(
          type: LessonBlockType.title,
          title: 'Misión 001',
          content: 'Qué es realmente un modelo de Inteligencia Artificial',
          prompt: 'Hoy vas a construir una idea clara que te servirá para entender todo lo que viene después.',
          sequence: 1,
        ),
        LessonBlock(
          type: LessonBlockType.text,
          title: 'Objetivo de aprendizaje',
          content:
              'Al terminar vas a poder explicar, con tus propias palabras, qué es un modelo de IA y distinguir aprendizaje de patrones de comprensión humana.',
          sequence: 2,
        ),
        LessonBlock(
          type: LessonBlockType.text,
          title: 'Explicación',
          content:
              'Un modelo de IA es un sistema matemático que aprende relaciones y patrones a partir de muchos ejemplos. Cuando recibe información nueva, usa esos patrones para predecir, clasificar o generar una respuesta. No guarda una lista perfecta de respuestas ni entiende como una persona: calcula qué resultado es más probable según lo aprendido.',
          items: <String>[
            'Aprende de datos y ejemplos.',
            'Aplica patrones a situaciones nuevas.',
            'Puede equivocarse aunque su respuesta parezca convincente.',
          ],
          sequence: 3,
        ),
        LessonBlock(
          type: LessonBlockType.analogy,
          title: 'Analogía',
          content:
              'Imaginá a una persona que escuchó miles de canciones. Al oír los primeros segundos de una canción nueva puede anticipar el estilo, el ritmo o qué instrumento aparecerá. No conoce el futuro: reconoce patrones. Un modelo hace algo parecido, pero con números y a una escala enorme.',
          sequence: 4,
        ),
        LessonBlock(
          type: LessonBlockType.example,
          title: 'Ejemplo práctico',
          content:
              'Un filtro de spam aprende observando miles de correos ya clasificados. Detecta relaciones entre palabras, enlaces, remitentes y decisiones anteriores. Ante un correo nuevo calcula si se parece más a los mensajes válidos o al spam.',
          prompt: 'La calidad del resultado depende de los ejemplos, la tarea y la información disponible.',
          sequence: 5,
        ),
        LessonBlock(
          type: LessonBlockType.challenge,
          title: 'Mini laboratorio',
          content:
              'Una empresa quiere detectar automáticamente mensajes urgentes de sus clientes. Elegí el conjunto de datos que mejor le enseñaría esa tarea al modelo.',
          sequence: 6,
        ),
        LessonBlock(
          type: LessonBlockType.quiz,
          title: 'Quiz',
          content:
              'Comprobá tu comprensión. Cada error incluye una explicación para ayudarte a ajustar el concepto.',
          sequence: 7,
        ),
        LessonBlock(
          type: LessonBlockType.summary,
          title: 'Resumen',
          content:
              'Un modelo de IA aprende patrones estadísticos de ejemplos y los aplica a información nueva. Puede clasificar, predecir o generar, pero no garantiza verdad ni comprensión humana.',
          items: <String>[
            'Datos de calidad producen mejores patrones.',
            'La respuesta depende también del contexto recibido.',
            'El criterio humano sigue siendo necesario para evaluar resultados.',
          ],
          sequence: 8,
        ),
        LessonBlock(
          type: LessonBlockType.summary,
          title: 'Misión lista para completar',
          content:
              'Ya tenés el concepto base para analizar cualquier herramienta de IA con más criterio.',
          prompt: 'Continuá para registrar tu progreso simulado y ver lo que aprendiste.',
          sequence: 9,
        ),
      ],
    );
  }
}
