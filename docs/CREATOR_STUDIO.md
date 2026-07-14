# ORÁCULO Creator Studio v1.0

ORÁCULO Creator Studio es la herramienta CMS interna y offline diseñada para que el equipo editorial y de desarrollo pueda crear, modificar y mantener todo el contenido curricular de ORÁCULO IA sin necesidad de editar archivos JSON a mano.

---

## 🚀 Acceso

El Creator Studio se ejecuta de manera integrada dentro de la aplicación. Para acceder:
1. Iniciá la aplicación en modo desarrollo o local.
2. Navegá a la pantalla **Estado Editorial** (desde el menú principal).
3. Hacé clic en el botón superior **Abrir Creator Studio**.

---

## 🛠️ Módulos de la Herramienta

La herramienta está organizada en pestañas de navegación:

### 1. Dashboard Principal
* Presenta estadísticas agregadas en tiempo real de todos los contenidos: cursos, módulos, misiones, laboratorios, proyectos, términos del glosario, artículos del manual y conceptos totales mapeados.
* Muestra de forma destacada el estado de validación semántica del motor de conocimiento.
* Enlista las fuentes del manifiesto que están marcadas con estado pendiente de revisión (`status != 'verificado'`).

### 2. Editor de Cursos
* Permite crear y editar rutas de carrera (`CareerPath`).
* Permite configurar el nivel, la duración estimada en horas y el texto de evaluación/objetivo final del curso.

### 3. Editor de Misiones (Lecciones)
* Ofrece un editor visual de bloques didácticos (Explicación, Analogía, Quiz, Resumen, etc.).
* Permite reordenar bloques didácticos mediante botones de movimiento (Mover Arriba / Mover Abajo) y agregar/eliminar bloques al instante.
* Permite editar y configurar cuestionarios interactivos directamente (texto de la pregunta, opciones de respuesta, respuesta correcta y explicación detallada).

### 4. Editor de Glosario
* Permite agregar términos al diccionario educativo, con su definición corta, explicación extendida, analogía y ejemplos prácticos.

### 5. Editor de Manual
* Permite redactar capítulos del manual técnico directamente con soporte completo para formato Markdown.

### 6. Biblioteca de Pensamiento
* Permite agregar ideas atribuidas a pensadores y autores tecnológicos.
* **Regla de integridad obligatoria:** El sistema bloquea el guardado si la idea está marcada como "cita textual" y carece de fuente documentada.

### 7. Laboratorios de Prompts
* Permite diseñar y documentar laboratorios prácticos de prompts, detallando el prompt original (ineficaz), el prompt mejorado y el análisis de la mejora.

### 8. Editor de Proyectos
* Permite diseñar proyectos prácticos finales de fin de track con sus objetivos, entregables, checklist de éxito y criterios de evaluación.

### 9. Validador Automático
* Corre un análisis cruzado del grafo de conocimiento en vivo, detectando:
  * **Conceptos huérfanos** (en glosario pero no enseñados en lecciones).
  * **Enlaces rotos** del diccionario.
  * **Preguntas de quiz** sin respuesta correcta asignada.
  * **Capítulos de manual** vacíos.
  * **IDs duplicados** entre colecciones.
  * **Referencias a misiones inexistentes** en cursos y proyectos.

---

## 💾 Persistencia y Exportación
Una vez que termines de hacer los cambios:
1. Hacé clic en el botón superior derecho **Exportar cambios (knowledge/)**.
2. El Creator Studio formateará y guardará automáticamente cada colección en su respectivo JSON bajo la carpeta `knowledge/` del proyecto.
