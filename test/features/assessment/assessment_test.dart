import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/assessment/domain/assessment.dart';

void main(){
  test('short answer is not treated as mastered',(){final result=const LocalRubricEvaluator().evaluate(assessmentTasks.first,'Un LLM responde.');expect(result.progress,0);expect(result.disclaimer,contains('ni garantiza'));});
  test('rich answer receives criterion-level feedback',(){final result=const LocalRubricEvaluator().evaluate(assessmentTasks.first,'El objetivo significa usar datos con una restricción clara porque existe un límite. Separaría cada hecho de un supuesto, evaluaría una alternativa y su riesgo. Para aplicar una acción mediría el resultado y usaría una fuente para verificar con revisión humana.');expect(result.met,greaterThan(3));expect(result.criteria,hasLength(6));});
  test('mastery tests exist every five missions',(){expect(assessmentTasks.where((item)=>item.masteryCheckpoint!=null).map((item)=>item.masteryCheckpoint),[5,10,15]);});
}
