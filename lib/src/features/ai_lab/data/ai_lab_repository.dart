import 'package:oraculo_ia/src/features/ai_lab/domain/ai_lab_models.dart';

class AiLabRepository {
  AiLabRepository._();
  static final instance = AiLabRepository._();

  final List<LabPracticeSession> _history = [];

  List<LabPracticeSession> get history => List.unmodifiable(_history);

  void saveSession(LabPracticeSession session) {
    _history.add(session);
  }

  // MÓDULO 6 — 10 PLANTILLAS REUTILIZABLES
  final List<PromptTemplate> templates = const [
    PromptTemplate(
      id: "tpl-resumir",
      title: "Resumir Ejecutivo",
      category: "Documentos",
      description: "Condensa informes extensos en 5 puntos de acción.",
      templateText: "Actúa como un analista senior. Resumí el siguiente informe delimitado por triple comilla en 5 puntos clave enfocados en: 1) decisión recomendada, 2) evidencia aportada, 3) riesgos, 4) datos ausentes, y 5) próximos pasos. Mantén el tono formal y profesional.\n\n\"\"\"\n[Pegar informe aquí]\n\"\"\"",
    ),
    PromptTemplate(
      id: "tpl-investigar",
      title: "Investigar Concepto",
      category: "Investigación",
      description: "Genera un mapa de estudio y preguntas de validación.",
      templateText: "Quiero estudiar el concepto de [Concepto]. Explicalo paso a paso desde los fundamentos hasta el nivel avanzado. Incluye:\n1. Definición analítica breve.\n2. Una analogía cotidiana no técnica.\n3. Un ejemplo práctico real.\n4. Tres preguntas difíciles de opción múltiple para autoevaluar mi comprensión.",
    ),
    PromptTemplate(
      id: "tpl-traducir",
      title: "Traducción Técnica",
      category: "Documentos",
      description: "Traduce manuales técnicos respetando un glosario estricto.",
      templateText: "Actúa como traductor técnico experto de inglés a español. Traducí el texto en <texto> respetando el siguiente glosario:\n- Pipeline -> Flujo lógico\n- Rate Limit -> Control de cuota\n- LLM -> Modelo de lenguaje\n\n<texto>\n[Pegar texto en inglés aquí]\n</texto>",
    ),
    PromptTemplate(
      id: "tpl-programar",
      title: "Programación Robusta",
      category: "Programación",
      description: "Crea funciones seguras con validaciones y manejo de errores.",
      templateText: "Escribí una función pura en [Lenguaje] para resolver el problema de [Problema]. Requisitos:\n1. Validar entradas y lanzar excepciones descriptivas.\n2. Evitar efectos colaterales de memoria.\n3. Agregar al menos 2 casos de prueba unitarios comentados.",
    ),
    PromptTemplate(
      id: "tpl-pdf",
      title: "Analizar Informes (PDFs)",
      category: "Documentos",
      description: "Extrae métricas cuantitativas e inconsistencias lógicas.",
      templateText: "Analizá el contenido extraído del PDF que se encuentra a continuación. Extrae una lista con todas las métricas cuantitativas, cifras financieras y fechas críticas citadas. Reportá cualquier inconsistencia de datos si encuentras contradicciones en los números.\n\n[Pegar texto del PDF aquí]",
    ),
    PromptTemplate(
      id: "tpl-tablas",
      title: "Generar Tablas de Datos",
      category: "Excel",
      description: "Estructura información sucia en formato Markdown limpio.",
      templateText: "Tomá el siguiente bloque de texto desordenado y ordenalo en una tabla Markdown con las columnas: [Columna 1], [Columna 2], [Columna 3]. Asegura que todas las celdas vacías contengan 'N/A' y justifica numéricamente el ordenamiento descendente de las filas.",
    ),
    PromptTemplate(
      id: "tpl-excel",
      title: "Fórmulas Excel de Negocio",
      category: "Excel",
      description: "Consigue la sintaxis correcta para condicionales complejos.",
      templateText: "Escribí una fórmula de Excel que evalúe las siguientes condiciones de negocio: si la venta supera [Meta] y el margen es mayor al [Porcentaje], calcular un bono del 10%, de lo contrario 0. Explicá cómo adecuar los separadores de lista de Excel según el idioma.",
    ),
    PromptTemplate(
      id: "tpl-automatizacion",
      title: "Automatización y APIs",
      category: "Automatización",
      description: "Define llamadas a endpoints y manejo de códigos HTTP.",
      templateText: "Diseñá un flujo que consuma un API de [Servicio]. Estructurá el prompt para que devuelva un JSON estricto con las llaves: 'action', 'params' y 'payload'. Evitá incluir texto explicativo fuera del JSON y detalla cómo manejar un error HTTP 429 de Rate Limit.",
    ),
    PromptTemplate(
      id: "tpl-reuniones",
      title: "Minutas y Acuerdos",
      category: "Productividad",
      description: "Compila notas de reuniones en acuerdos y responsables.",
      templateText: "A partir de la siguiente transcripción de reunión, redactá una minuta ejecutiva compacta. Identificá claramente: 1) objetivos del encuentro, 2) decisiones tomadas por consenso, 3) acuerdos concretos y responsables asignados con fecha límite.\n\n[Pegar transcripción aquí]",
    ),
    PromptTemplate(
      id: "tpl-brainstorming",
      title: "Brainstorming Estructurado",
      category: "Productividad",
      description: "Genera ideas creativas categorizadas por riesgo y ROI.",
      templateText: "Generá 10 ideas creativas para resolver [Problema]. Para cada idea, incluí en una tabla de dos columnas: una descripción corta de la solución propuesta y el nivel estimado de riesgo técnico (Bajo/Medio/Alto) con su impacto proyectado de ROI.",
    ),
  ];

  // MÓDULO 5 — MOTOR DE EVALUACIÓN LOCAL DETERMINISTA
  PromptEvaluationResult evaluatePrompt(String prompt) {
    final cleanPrompt = prompt.trim().toLowerCase();
    
    if (cleanPrompt.isEmpty) {
      return const PromptEvaluationResult(
        score: 0,
        clarityScore: 0,
        clarityExplanation: "El prompt está vacío.",
        contextScore: 0,
        contextExplanation: "No hay contexto.",
        restrictionsScore: 0,
        restrictionsExplanation: "No hay restricciones.",
        formatScore: 0,
        formatExplanation: "No hay formato especificado.",
        objectiveScore: 0,
        objectiveExplanation: "No hay objetivo.",
        suggestions: ["Escribe una instrucción para iniciar la evaluación."],
      );
    }

    // 1. Claridad: presencia de verbos de acción imperativos
    int clarity = 0;
    final actionVerbs = ["resumí", "creá", "analizá", "diseñá", "redactá", "traducí", "explicá", "buscá", "escribí", "generá", "evaluá"];
    for (final verb in actionVerbs) {
      if (cleanPrompt.contains(verb)) clarity += 35;
    }
    if (cleanPrompt.length > 30) clarity += 30;
    if (clarity > 100) clarity = 100;
    final clarityExpl = clarity >= 65 
        ? "Excelente. El prompt utiliza verbos imperativos claros y directos." 
        : "Faltan verbos de acción imperativos claros (e.g. 'resumí', 'diseñá').";

    // 2. Contexto: especificar rol, audiencia o entorno
    int context = 0;
    final contextKeywords = ["rol", "actúa", "como", "contexto", "analista", "experto", "consultor", "programador", "audiencia"];
    for (final kw in contextKeywords) {
      if (cleanPrompt.contains(kw)) context += 30;
    }
    if (context > 100) context = 100;
    final contextExpl = context >= 60 
        ? "Excelente. Defines un rol o contexto situacional preciso." 
        : "Se recomienda establecer un rol de experto o contextualizar los antecedentes.";

    // 3. Restricciones: qué evitar o límites de tamaño
    int restrictions = 0;
    final restKeywords = ["evitá", "nunca", "no", "límite", "restricción", "máximo", "palabras", "sin inventar"];
    for (final kw in restKeywords) {
      if (cleanPrompt.contains(kw)) restrictions += 30;
    }
    if (restrictions > 100) restrictions = 100;
    final restExpl = restrictions >= 60 
        ? "Muy bien. Declaras límites claros o pautas de exclusión." 
        : "Agrega pautas negativas para evitar respuestas redundantes o alucinaciones (e.g. 'evitá explicaciones largas').";

    // 4. Formato: especificar estructura de salida
    int format = 0;
    final formatKeywords = ["markdown", "json", "tabla", "lista", "esquema", "columnas", "formato", "delimitado"];
    for (final kw in formatKeywords) {
      if (cleanPrompt.contains(kw)) format += 30;
    }
    if (format > 100) format = 100;
    final formatExpl = format >= 60 
        ? "Correcto. El prompt detalla la estructura visual o formato de salida esperado." 
        : "Especifica explícitamente el formato (e.g. 'devolver en tabla Markdown').";

    // 5. Objetivo: meta clara
    int objective = 0;
    if (cleanPrompt.contains("para") || cleanPrompt.contains("objetivo") || cleanPrompt.contains("con el fin de")) {
      objective = 100;
    } else if (cleanPrompt.length > 60) {
      objective = 70;
    } else {
      objective = 30;
    }
    final objExpl = objective >= 70 
        ? "Meta de procesamiento clara." 
        : "Explicita la finalidad de la consulta para afinar la intención didáctica.";

    // Calcular puntaje total
    final totalScore = ((clarity + context + restrictions + format + objective) / 5).round();

    // Sugerencias personalizadas
    final suggestions = <String>[];
    if (clarity < 65) suggestions.add("Comienza con una orden imperativa clara: 'Actúa como...', 'Resumí...'.");
    if (context < 60) suggestions.add("Provee contexto: especifica a qué público va dirigido o qué rol asume el modelo.");
    if (restrictions < 60) suggestions.add("Agrega restricciones negativas: 'No incluyas introducciones ni resúmenes'.");
    if (format < 60) suggestions.add("Detalla el formato final: 'Devolver en una lista de 5 puntos con títulos en negrita'.");
    if (suggestions.isEmpty) suggestions.add("El prompt está óptimamente estructurado.");

    return PromptEvaluationResult(
      score: totalScore,
      clarityScore: clarity,
      clarityExplanation: clarityExpl,
      contextScore: context,
      contextExplanation: contextExpl,
      restrictionsScore: restrictions,
      restrictionsExplanation: restExpl,
      formatScore: format,
      formatExplanation: formatExpl,
      objectiveScore: objective,
      objectiveExplanation: objExpl,
      suggestions: suggestions,
    );
  }
}
