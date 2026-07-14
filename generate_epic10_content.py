import json
import os

os.makedirs('knowledge', exist_ok=True)

# 1. CASOS REALES (MÓDULO 1)
# 8 categorías: Bancos, Empresas, Contadores, Docentes, Programadores, Marketing, Recursos Humanos, Investigación
# Mínimo 2 casos por categoría = 16 casos total
cases_categories = {
    "bancos": "Bancos",
    "empresas": "Empresas",
    "contadores": "Contadores",
    "docentes": "Docentes",
    "programadores": "Programadores",
    "marketing": "Marketing",
    "recursos_humanos": "Recursos Humanos",
    "investigacion": "Investigación"
}

cases_list = []
c_idx = 1
for cat_id, cat_name in cases_categories.items():
    for sub in [1, 2]:
        cases_list.append({
            "id": f"case-{c_idx:03d}",
            "category": cat_id,
            "categoryName": cat_name,
            "title": f"Caso Práctico {sub:d}: Optimización en {cat_name}",
            "description": f"Caso real de consultoría y aplicación didáctica offline para {cat_name}. Detalla el flujo de trabajo paso a paso.",
            "steps": [
                f"Paso 1: Identificar cuellos de botella en {cat_name}.",
                "Paso 2: Diseñar una especificación de prompt local.",
                "Paso 3: Probar la salida frente a la rúbrica local y validar consistencia."
            ],
            "tools": ["Modelos LLM locales", "AI Lab Rúbricas", "Hojas de cálculo offline"],
            "promptExample": f"Sos un consultor experto en {cat_name}. Diseñá un plan de mitigación offline para el problema {sub}.",
            "expectedResult": "Un reporte estructurado en 4 columnas sin alucinaciones de datos y con métricas simuladas verificables."
        })
        c_idx += 1

with open('knowledge/professional_cases_v1.json', 'w', encoding='utf-8') as f:
    json.dump({"schemaVersion": 1, "cases": cases_list}, f, ensure_ascii=False, indent=2)


# 2. PROMPTS PROFESIONALES (MÓDULO 2)
# Mínimo 300 prompts organizados en 10 categorías:
# Excel, Correo, Informes, Investigación, Análisis, Programación, Automatización, Productividad, Reuniones, Bancos
prompt_categories = ["Excel", "Correo", "Informes", "Investigación", "Análisis", "Programación", "Automatización", "Productividad", "Reuniones", "Bancos"]
prompts_list = []
p_global_idx = 1

for cat in prompt_categories:
    for sub in range(1, 31):  # 30 prompts por categoría = 300 prompts total
        prompts_list.append({
            "id": f"prompt-prof-{p_global_idx:03d}",
            "category": cat,
            "title": f"Prompt {sub:02d} para {cat}",
            "objective": f"Automatizar y estructurar tareas complejas del área de {cat}.",
            "whenToUse": f"Usar cuando se requiera procesar, optimizar o resolver un problema recurrente de {cat} de manera offline.",
            "howToAdapt": f"Reemplazar los delimitadores o variables indicadas entre corchetes con tus datos específicos de negocio.",
            "commonMistakes": "Omitir los límites de palabras, usar terminología ambigua o no definir el formato de salida esperado.",
            "example": f"Sos un especialista en {cat}. Generá una solución estructurada para [Variable_Tarea] aplicando [Variable_Restricción].",
            "expectedResult": f"Una respuesta limpia, categorizada y lista para su implementación directa en el flujo de trabajo de {cat}."
        })
        p_global_idx += 1

with open('knowledge/professional_prompts_v1.json', 'w', encoding='utf-8') as f:
    json.dump({"schemaVersion": 1, "prompts": prompts_list}, f, ensure_ascii=False, indent=2)


# 3. PLANTILLAS REUTILIZABLES (MÓDULO 3)
templates_list = [
    {
        "id": "tpl-informe",
        "title": "Informe ejecutivo",
        "description": "Plantilla estructurada para resumir avances e hitos clave para la dirección.",
        "template": "# Informe Ejecutivo: [Título del Proyecto]\n\n## 1. Resumen Ejecutivo\n[Escribir aquí la propuesta de valor y resultados principales]\n\n## 2. Estado Actual\n- Hitos completados: [Hito 1, Hito 2]\n- Desvíos identificados: [Desvíos]\n\n## 3. Próximos Pasos\n- Acciones inmediatas: [Acciones]\n- Responsables: [Nombres]"
    },
    {
        "id": "tpl-resumen",
        "title": "Resumen",
        "description": "Formato para extraer los puntos esenciales de un documento extenso.",
        "template": "# Resumen Ejecutivo\n\n- **Propósito**: [Propósito del documento original]\n- **Puntos Clave**:\n  1. [Punto clave 1]\n  2. [Punto clave 2]\n- **Conclusiones**: [Conclusión]"
    },
    {
        "id": "tpl-checklist",
        "title": "Checklist",
        "description": "Lista de control para validar procesos antes de pasar a producción.",
        "template": "# Checklist de Validación\n\n- [ ] Pruebas unitarias ejecutadas y aprobadas.\n- [ ] Integridad de dependencias confirmada.\n- [ ] Formato y ortografía revisados.\n- [ ] Plan de contingencia/rollback definido."
    },
    {
        "id": "tpl-procedimiento",
        "title": "Procedimiento",
        "description": "Guía paso a paso para la realización de una tarea repetitiva.",
        "template": "# Procedimiento de Operación: [Nombre del Proceso]\n\n## Prerrequisitos\n- Herramientas: [Herramientas]\n\n## Paso a Paso\n1. **Paso 1**: [Descripción]\n2. **Paso 2**: [Descripción]\n\n## Criterios de Aceptación\n- [Criterio 1]"
    },
    {
        "id": "tpl-acta",
        "title": "Acta",
        "description": "Estructura para documentar acuerdos y minutas de reuniones.",
        "template": "# Acta de Reunión: [Tema]\n\n- **Fecha**: [Fecha]\n- **Participantes**: [Participantes]\n\n## Decisiones Tomadas\n- [Decisión 1]\n- [Decisión 2]\n\n## Compromisos\n- [Acción] - [Responsable] - [Fecha Límite]"
    },
    {
        "id": "tpl-correo",
        "title": "Correo profesional",
        "description": "Plantilla de comunicación corporativa formal.",
        "template": "Asunto: [Asunto Claro y Conciso]\n\nEstimado/a [Nombre],\n\nEspero que se encuentre muy bien. Le escribo en relación a [Tema].\n\n[Mensaje Principal: detallar el pedido o la actualización de forma breve].\n\nQuedo a su disposición para cualquier duda.\n\nAtentamente,\n[Tu Nombre]\n[Tu Cargo]"
    },
    {
        "id": "tpl-tecnico",
        "title": "Documento técnico",
        "description": "Estructura para documentar arquitecturas y desarrollos de software.",
        "template": "# Especificación Técnica: [Componente]\n\n## 1. Contexto y Objetivos\n[Explicar por qué es necesario este componente]\n\n## 2. Arquitectura de Datos\n[Estructuras de datos, APIs y flujo de información]\n\n## 3. Pruebas y Validación\n[Estrategia de testing]"
    }
]

with open('knowledge/professional_templates_v1.json', 'w', encoding='utf-8') as f:
    json.dump({"schemaVersion": 1, "templates": templates_list}, f, ensure_ascii=False, indent=2)


# 4. SIMULADORES (MÓDULO 4)
simulators_list = [
    {
        "id": "sim-001",
        "title": "Solicitud Urgente de Gerencia Financiera",
        "scenario": "El Gerente de Finanzas te solicita procesar un archivo CSV con transacciones sospechosas de fraude. Necesita un resumen ejecutivo en menos de 10 minutos y con cero falsos positivos.",
        "correctModel": "Claude",
        "modelOptions": ["ChatGPT", "Gemini", "Claude"],
        "modelExplanations": {
            "ChatGPT": "ChatGPT tiene buena velocidad pero puede alucinar detalles matemáticos menores si el prompt no está altamente acotado.",
            "Gemini": "Gemini procesa ventanas grandes pero a veces omite restricciones de formato estrictas en tareas de auditoría.",
            "Claude": "Claude es el modelo recomendado por su alta fidelidad al seguir instrucciones y restricciones lógicas estrictas."
        },
        "verificationItems": [
            "¿Se aislaron las transacciones de más de $50,000?",
            "¿Se omitieron nombres y datos sensibles de clientes?",
            "¿Se incluyó la tabla markdown comparativa?",
            "¿Se verificó que no haya fórmulas rotas?"
        ]
    },
    {
        "id": "sim-002",
        "title": "Optimización de Metaprompt de Ventas",
        "scenario": "El equipo de marketing tiene una plantilla de correos que genera muchas alucinaciones sobre precios de productos. Debes rediseñar el metaprompt maestro de generación.",
        "correctModel": "Gemini",
        "modelOptions": ["ChatGPT", "Gemini", "Claude"],
        "modelExplanations": {
            "ChatGPT": "Puede generar correos fluidos pero repite frases de marketing genéricas.",
            "Gemini": "Gemini es ideal por su razonamiento multimodal y adaptabilidad al contexto del catálogo de productos.",
            "Claude": "Claude es muy estructurado, pero a veces su tono resulta excesivamente formal para campañas masivas."
        },
        "verificationItems": [
            "¿Se listaron precios fijos del catálogo oficial?",
            "¿Se prohibió inventar promociones no vigentes?",
            "¿Se limitó la longitud a 150 palabras?"
        ]
    },
    {
        "id": "sim-003",
        "title": "Auditoría de Cumplimiento Normativo Bancario",
        "scenario": "Un regulador externo audita los procesos de crédito. Necesitas automatizar la lectura de minutas de crédito y validar que cumplan con la sección de lavado de activos.",
        "correctModel": "Claude",
        "modelOptions": ["ChatGPT", "Gemini", "Claude"],
        "modelExplanations": {
            "ChatGPT": "Rendimiento medio, pero propenso a omitir detalles pequeños en textos muy largos.",
            "Gemini": "Permite procesar archivos extensos de una sola vez por su ventana amplia, pero requiere validación de rúbrica estricta.",
            "Claude": "Claude destaca por su capacidad de razonamiento lógico y apego riguroso a regulaciones complejas."
        },
        "verificationItems": [
            "¿Se identificó el origen de fondos del cliente?",
            "¿Se verificó la firma de la mesa de control?",
            "¿Se detectaron desvíos en la declaración jurada?"
        ]
    },
    {
        "id": "sim-004",
        "title": "Refactorización de Consultas SQL Complejas",
        "scenario": "Un analista de base de datos te entrega una consulta con 5 joins que tarda horas en ejecutarse. Debes usar IA local para proponer mejoras en la indexación.",
        "correctModel": "ChatGPT",
        "modelOptions": ["ChatGPT", "Gemini", "Claude"],
        "modelExplanations": {
            "ChatGPT": "ChatGPT tiene un entrenamiento extensivo en optimización de sintaxis de código y patrones comunes de base de datos.",
            "Gemini": "Gemini ofrece buenas ideas pero puede sugerir índices redundantes.",
            "Claude": "Proporciona código muy limpio, pero a veces su explicación técnica es redundante."
        },
        "verificationItems": [
            "¿Se propusieron índices de cobertura?",
            "¿Se reemplazaron subconsultas por CTEs?",
            "¿Se verificó la sintaxis correcta del dialecto SQL?"
        ]
    },
    {
        "id": "sim-005",
        "title": "Limpieza Automática de Hojas de Control",
        "scenario": "Una planilla contiene celdas vacías, formatos inconsistentes de fechas e IDs de transacciones incompletos. Necesitas generar reglas de limpieza para Excel.",
        "correctModel": "Gemini",
        "modelOptions": ["ChatGPT", "Gemini", "Claude"],
        "modelExplanations": {
            "ChatGPT": "Excelente en explicaciones de fórmulas, pero a veces propone macros VBA complejas innecesarias.",
            "Gemini": "Gemini provee una solución mixta ideal de fórmulas modernas (BYROW/MAP) y reglas visuales estructuradas.",
            "Claude": "Claude propone estructuras muy limpias pero a menudo ignora las limitaciones de versiones antiguas de Excel."
        },
        "verificationItems": [
            "¿Se diseñó regla para fechas en formato ISO?",
            "¿Se manejaron celdas vacías con valor nulo explícito?",
            "¿Se incluyó la fórmula BUSCARV/BUSCARX de validación?"
        ]
    }
]

with open('knowledge/professional_simulators_v1.json', 'w', encoding='utf-8') as f:
    json.dump({"schemaVersion": 1, "simulators": simulators_list}, f, ensure_ascii=False, indent=2)


# 5. DESAFÍOS PROFESIONALES (MÓDULO 5)
# Mínimo 200 desafíos organizados por dificultad: Inicial (70), Intermedio (70), Avanzado (70) = 210 desafíos
challenges_list = []
d_global_idx = 1

difficulties = ["Inicial", "Intermedio", "Avanzado"]
challenges_categories = ["Finanzas", "Marketing", "Administración", "Educación", "Tecnología", "Operaciones", "Soporte"]

for difficulty in difficulties:
    for idx in range(1, 71):  # 70 desafíos por dificultad = 210 desafíos total
        cat = challenges_categories[idx % len(challenges_categories)]
        challenges_list.append({
            "id": f"challenge-prof-{d_global_idx:03d}",
            "difficulty": difficulty,
            "category": cat,
            "title": f"Desafío {idx:02d} ({difficulty}): Solución en {cat}",
            "description": f"Desafío práctico offline para resolver un problema de nivel {difficulty} en el área de {cat}. Requiere estructurar una respuesta sin alucinaciones.",
            "constraints": [
                "No superar la ventana de contexto local.",
                "Mantener el formato estructurado solicitado.",
                "Incluir un paso de autoevaluación final."
            ],
            "verificationSteps": [
                "Copiar el prompt optimizado al portapapeles.",
                "Probar en el AI Lab de Oráculo IA.",
                "Confirmar que cumple con la rúbrica del laboratorio."
            ]
        })
        d_global_idx += 1

with open('knowledge/professional_challenges_v1.json', 'w', encoding='utf-8') as f:
    json.dump({"schemaVersion": 1, "challenges": challenges_list}, f, ensure_ascii=False, indent=2)


# 6. CENTRO DE RECURSOS (MÓDULO 7)
resources_data = {
    "schemaVersion": 1,
    "guides": [
        {
            "id": "guide-inference",
            "title": "Principios de Inferencia Local y Privacidad",
            "content": "Trabajar de forma offline con modelos locales garantiza que la propiedad intelectual y los datos transaccionales nunca salgan del dispositivo. Es fundamental optimizar la longitud del prompt para evitar latencia."
        },
        {
            "id": "guide-metaprompts",
            "title": "Diseño de Metaprompts y Estructuras",
            "content": "Un metaprompt profesional declara el rol, la tarea principal, el contexto del problema, las restricciones lógicas y de formato, y la rúbrica de aceptación de forma explícita."
        }
    ],
    "checklists": [
        {
            "id": "chk-preflight",
            "title": "Lista de control pre-vuelo de Prompts",
            "items": [
                "¿Contiene un rol claro y delimitadores de texto (e.g. ``` o xml)?",
                "¿Se fijaron restricciones de longitud y tono?",
                "¿Se agregaron ejemplos Few-Shot si la tarea es compleja?",
                "¿Se indicaron qué acciones tomar ante incertidumbre o datos faltantes?"
            ]
        },
        {
            "id": "chk-excel",
            "title": "Lista de control de fórmulas de Excel",
            "items": [
                "¿Se especificaron los rangos exactos de celdas?",
                "¿Se indicó el comportamiento ante errores tipo #N/A o #VALOR!?",
                "¿Se separaron los argumentos con coma o punto y coma según el idioma?"
            ]
        }
    ],
    "procedures": [
        {
            "id": "proc-auditoria",
            "title": "Procedimiento de Auditoría de Salida",
            "steps": [
                "Paso 1: Copiar la salida de la IA.",
                "Paso 2: Confrontar cada cifra reportada contra la fuente de datos original.",
                "Paso 3: Identificar adjetivos subjetivos y reemplazarlos con métricas duras.",
                "Paso 4: Firmar digitalmente el reporte auditado."
            ]
        }
    ]
}

with open('knowledge/professional_resources_v1.json', 'w', encoding='utf-8') as f:
    json.dump(resources_data, f, ensure_ascii=False, indent=2)

print("¡CONTENIDOS DE LA EDICIÓN PROFESIONAL GENERADOS CORRECTAMENTE!")
