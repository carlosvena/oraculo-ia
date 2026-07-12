import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

enum ReviewActivityType { recallCard, shortQuestion, applicationCase, promptRepair }
class ReviewItem {
  const ReviewItem({required this.concept,required this.reason,required this.nextReview,required this.type,required this.prompt,required this.explanation});
  final String concept,reason,prompt,explanation;
  final DateTime nextReview;
  final ReviewActivityType type;
}
class ReviewPlan {const ReviewPlan({required this.minutes,required this.items});final int minutes;final List<ReviewItem> items;}

class LocalReviewEngine {
  const LocalReviewEngine();
  ReviewPlan create(LearningState state,int minutes,{DateTime? now}){
    final today=now??DateTime.now();final weighted=<String,int>{};
    for(final value in state.mistakeConcepts){weighted[value]=(weighted[value]??0)+4;}
    for(final value in state.reviewConcepts){weighted[value]=(weighted[value]??0)+3;}
    for(final entry in state.confidence.entries){if(entry.value<3){weighted[entry.key]=(weighted[entry.key]??0)+(4-entry.value);}}
    for(final entry in state.reviews.entries){if(entry.value!=ReviewLevel.understood){weighted[entry.key]=(weighted[entry.key]??0)+2;}}
    if(weighted.isEmpty){for(final value in state.masteredConcepts.take(6)){weighted[value]=1;}}
    final ordered=weighted.entries.toList()..sort((a,b)=>b.value.compareTo(a.value));
    final count=minutes<=5?2:minutes<=15?5:8;
    final types=ReviewActivityType.values;
    return ReviewPlan(minutes:minutes,items:[for(final (index,entry) in ordered.take(count).indexed)ReviewItem(concept:entry.key,reason:_reason(state,entry.key,today),nextReview:today.add(Duration(days:(state.confidence[entry.key]??1)*2)),type:types[index%types.length],prompt:_prompt(types[index%types.length],entry.key),explanation:'Compará tu respuesta con la misión relacionada: definí el concepto, aplicalo a un caso y explicá cómo verificarías el resultado.')]);
  }
  String _reason(LearningState state,String concept,DateTime now){if(state.mistakeConcepts.contains(concept))return 'Fue seleccionado por un error anterior.';if(state.reviewConcepts.contains(concept))return 'Lo marcaste como difícil o para repasar.';if((state.confidence[concept]??3)<3)return 'Declaraste seguridad baja.';if(state.lastStudyEpoch>0&&now.difference(DateTime.fromMillisecondsSinceEpoch(state.lastStudyEpoch)).inDays>=3)return 'Pasaron varios días desde el último estudio.';return 'Conviene recuperarlo antes de que se debilite.';}
  String _prompt(ReviewActivityType type,String concept)=>switch(type){ReviewActivityType.recallCard=>'Sin mirar, definí $concept en dos frases.',ReviewActivityType.shortQuestion=>'¿Qué problema resuelve $concept y qué no garantiza?',ReviewActivityType.applicationCase=>'Aplicá $concept a una decisión de supervisión bancaria.',ReviewActivityType.promptRepair=>'Corregí una instrucción que use $concept sin contexto ni verificación.'};
}
