import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/mentor/data/mentor_engine.dart';
import 'package:oraculo_ia/src/features/mentor/domain/llm_adapters.dart';
import 'package:oraculo_ia/src/features/mentor/domain/mentor_events.dart';

void main() {
  group('Mentor Engine Tests', () {
    late MentorEngine engine;

    setUp(() {
      engine = MentorEngine.instance;
    });

    test('Engine is a singleton and has initial profile', () {
      expect(engine, isNotNull);
      expect(engine.profile.name, 'Carlos');
      expect(engine.profile.level, 'Intermedio');
    });

    test('Reacts to ConceptFailed event by tracking error and adapting difficulty', () {
      final initialDiff = engine.profile.difficulty; // Exigente
      expect(initialDiff, 'Exigente');

      // Simular fallo
      engine.notify(ConceptFailed(concept: 'alucinaciones'));
      
      expect(engine.profile.frequentErrors['alucinaciones'], 3); // 2 + 1
      expect(engine.profile.difficulty, 'Intermedio'); // Bajó de Exigente a Intermedio
    });

    test('Reacts to ConceptLearned event by adapting difficulty back up', () {
      engine.notify(ConceptLearned(concept: 'criterio'));
      expect(engine.profile.difficulty, 'Exigente'); // Subió de Intermedio a Exigente
    });

    test('Recommender provides relevant suggestions and reasons', () {
      final rec = engine.getRecommendation();
      expect(rec.type, isNotEmpty);
      expect(rec.target, isNotEmpty);
      expect(rec.reason, isNotEmpty);
    });

    test('Alternative explanations engine returns quality deterministic styling', () {
      final expFormal = engine.getAlternativeExplanation('prompts', ExplanationStyle.formal);
      expect(expFormal, contains('especificación estructurada'));

      final expAnalogia = engine.getAlternativeExplanation('prompts', ExplanationStyle.analogia);
      expect(expAnalogia, contains('volante de un auto'));
      expect(engine.usedAnalogies, contains(expAnalogia));
    });

    test('Study planner builds micro and macro plans based on available time', () {
      final microPlan = engine.generatePlan(15, 'Aprender Prompt Engineering');
      expect(microPlan.steps.first, contains('Glosario'));

      final macroPlan = engine.generatePlan(60, 'Construir un agente conceptual');
      expect(macroPlan.steps, anyElement(contains('Misión Práctica')));
    });

    test('LLM adapters satisfy request signatures and return mock results', () async {
      const openAi = OpenAiAdapter();
      final explanation = await openAi.requestExplanation(
        concept: 'agentes',
        style: 'simple',
        learnerContext: 'Nivel: Intermedio',
      );
      expect(explanation, contains('[OpenAI Response]'));

      const gemini = GeminiAdapter();
      final geminiExplanation = await gemini.requestExplanation(
        concept: 'agentes',
        style: 'analogia',
        learnerContext: 'Nivel: Intermedio',
      );
      expect(geminiExplanation, contains('[Gemini Response]'));
    });
  });
}
