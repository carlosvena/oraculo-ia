enum AssessmentKind { openExplanation, promptCorrection, errorDetection, caseResolution, solutionDesign, comparison }

class RubricCriterion {
  const RubricCriterion({required this.name, required this.guidance, required this.signals});
  final String name, guidance;
  final List<String> signals;
}

class AssessmentTask {
  const AssessmentTask({required this.id, required this.title, required this.prompt, required this.kind, required this.rubric, required this.solidExample, this.masteryCheckpoint});
  final String id, title, prompt, solidExample;
  final AssessmentKind kind;
  final List<RubricCriterion> rubric;
  final int? masteryCheckpoint;
}

class CriterionFeedback {
  const CriterionFeedback({required this.name, required this.met, required this.message});
  final String name, message;
  final bool met;
}

class AssessmentFeedback {
  const AssessmentFeedback({required this.criteria, required this.disclaimer});
  final List<CriterionFeedback> criteria;
  final String disclaimer;
  int get met => criteria.where((item) => item.met).length;
  double get progress => criteria.isEmpty ? 0 : met / criteria.length;
}

class LocalRubricEvaluator {
  const LocalRubricEvaluator();
  AssessmentFeedback evaluate(AssessmentTask task, String answer) {
    final normalized = answer.toLowerCase();
    final words = normalized.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
    final feedback = task.rubric.map((criterion) {
      final hits = criterion.signals.where((signal) => normalized.contains(signal.toLowerCase())).length;
      final met = hits >= (criterion.signals.length > 2 ? 2 : 1) && words >= 25;
      return CriterionFeedback(
        name: criterion.name,
        met: met,
        message: met ? 'Bien: tu respuesta aporta evidencia relacionada con ${criterion.name.toLowerCase()}.' : 'Falta fortalecer ${criterion.name.toLowerCase()}: ${criterion.guidance}',
      );
    }).toList();
    return AssessmentFeedback(criteria: feedback, disclaimer: 'Esta devolución local usa señales editoriales. No comprende tu respuesta como una persona ni garantiza una corrección perfecta. Usala para revisar, no como veredicto final.');
  }
}

const professionalRubric = <RubricCriterion>[
  RubricCriterion(name:'Comprensión',guidance:'definí la idea con tus palabras y explicá el mecanismo.',signals:['porque','significa','funciona']),
  RubricCriterion(name:'Precisión',guidance:'separá hechos, supuestos y límites.',signals:['hecho','supuesto','límite']),
  RubricCriterion(name:'Contexto',guidance:'indicá objetivo, datos disponibles y restricciones.',signals:['objetivo','datos','restricción']),
  RubricCriterion(name:'Aplicación',guidance:'incluí una acción concreta y un resultado observable.',signals:['aplicar','acción','resultado']),
  RubricCriterion(name:'Pensamiento crítico',guidance:'compará alternativas y explicá el costo de elegir.',signals:['alternativa','ventaja','riesgo']),
  RubricCriterion(name:'Verificación',guidance:'definí fuente, control y responsable.',signals:['fuente','verificar','revisión']),
];

const assessmentTasks = <AssessmentTask>[
  AssessmentTask(id:'explain-llm',title:'Explicación con palabras propias',kind:AssessmentKind.openExplanation,prompt:'Explicale a un colega qué hace un LLM, qué no hace y cómo verificarías una respuesta usada en el trabajo.',rubric:professionalRubric,solidExample:'Un LLM predice continuaciones a partir de patrones. Puede redactar y relacionar contexto, pero no garantiza verdad. En un informe separaría afirmaciones y comprobaría cifras contra la fuente oficial vigente.'),
  AssessmentTask(id:'repair-prompt',title:'Corregir un prompt deficiente',kind:AssessmentKind.promptCorrection,prompt:'Mejorá este prompt: “Analizá estos casos y decime qué hacer”. Incluí objetivo, contexto, entradas, restricciones, formato y verificación.',rubric:professionalRubric,solidExample:'Actuá como asistente de análisis. Con los casos anonimizados adjuntos, identificá tendencias sin decidir acciones sobre clientes. Entregá tabla de hechos, incertidumbres y fuentes; marcá faltantes y solicitá revisión del supervisor.'),
  AssessmentTask(id:'detect-error',title:'Detectar errores',kind:AssessmentKind.errorDetection,prompt:'Una respuesta cita una norma sin enlace, mezcla dos períodos y recomienda actuar. Detectá errores, ordenalos por riesgo y proponé controles.',rubric:professionalRubric,solidExample:'Detendría la recomendación. Verificaría existencia, vigencia y alcance de la norma en la fuente primaria; separaría períodos y reconciliaría cifras. La decisión queda en revisión humana.'),
  AssessmentTask(id:'case-bank',title:'Resolver un caso',kind:AssessmentKind.caseResolution,prompt:'Diseñá cómo usar IA para resumir incidentes bancarios semanales sin exponer datos ni ocultar incertidumbre.',rubric:professionalRubric,solidExample:'Anonimizar entradas, validar permisos, recuperar procedimientos vigentes, producir borrador con citas, reconciliar cifras, declarar faltantes y exigir aprobación antes de distribuir.'),
  AssessmentTask(id:'compare-solutions',title:'Comparar alternativas',kind:AssessmentKind.comparison,prompt:'Compará un servicio cerrado y un modelo desplegado localmente para documentos internos. Elegí según riesgo, operación y costo total.',rubric:professionalRubric,solidExample:'El servicio reduce operación pero exige contrato y controles de datos; el local ofrece control, no seguridad automática, y suma infraestructura. Haría una prueba con datos sintéticos y matriz ponderada.'),
  AssessmentTask(id:'mastery-005',title:'Prueba de dominio 005',kind:AssessmentKind.solutionDesign,prompt:'Construí una solución completa para mejorar un prompt laboral: diagnóstico, versión profesional, prueba y verificación.',rubric:professionalRubric,solidExample:'Una respuesta sólida explicita objetivo, entradas, límites, salida, casos de prueba, criterio de aceptación y revisión humana.',masteryCheckpoint:5),
  AssessmentTask(id:'mastery-010',title:'Prueba de dominio 010',kind:AssessmentKind.solutionDesign,prompt:'Elegí un modelo para una tarea sensible y defendé la decisión con una matriz de capacidad, privacidad, costo y evidencia.',rubric:professionalRubric,solidExample:'Una respuesta sólida compara alternativas con pesos explícitos, fuentes fechadas, prueba controlada y condición de salida.',masteryCheckpoint:10),
  AssessmentTask(id:'mastery-015',title:'Prueba de dominio 015',kind:AssessmentKind.solutionDesign,prompt:'Diseñá un sistema asistido completo: prompt, modelo, fuentes, automatización, controles, métricas y reflexión final.',rubric:professionalRubric,solidExample:'Una respuesta sólida separa pasos deterministas y probabilísticos, permisos, evidencia, excepciones, aprobación y auditoría.',masteryCheckpoint:15),
];
