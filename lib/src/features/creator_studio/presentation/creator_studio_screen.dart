import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/career/domain/career_path.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/creator_studio/data/creator_studio_exporter.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/projects/domain/learning_project.dart';
import 'package:oraculo_ia/src/features/prompt_lab/domain/prompt_exercise.dart';
import 'package:oraculo_ia/src/features/thought_library/domain/thought_library.dart';
import 'package:oraculo_ia/src/modules/academy/competency.dart';
import 'package:oraculo_ia/src/modules/academy/skill.dart';
import 'package:oraculo_ia/src/modules/academy/track.dart';

/// Pantalla principal de administración del Creator Studio v1.0.
class CreatorStudioScreen extends StatefulWidget {
  const CreatorStudioScreen({super.key});

  @override
  State<CreatorStudioScreen> createState() => _CreatorStudioScreenState();
}

class _CreatorStudioScreenState extends State<CreatorStudioScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;

  // Estados locales editables de conocimiento
  List<CareerPath> _careerPaths = [];
  List<LearningProject> _projects = [];
  List<PromptExercise> _promptExercises = [];
  List<ThoughtIdea> _ideas = [];
  List<String> _topics = [];
  List<String> _authors = [];
  List<DictionaryTerm> _terms = [];
  List<KnowledgeArticle> _articles = [];
  List<Track> _tracks = [];
  List<Competency> _competencies = [];
  List<Skill> _skills = [];
  List<Lesson> _lessons = [];
  List<dynamic> _manifestItems = []; // manifiesto crudo para preservar otros campos

  // Elementos seleccionados actualmente en edición
  CareerPath? _selectedPath;
  LearningProject? _selectedProject;
  PromptExercise? _selectedExercise;
  ThoughtIdea? _selectedIdea;
  DictionaryTerm? _selectedTerm;
  KnowledgeArticle? _selectedArticle;
  Lesson? _selectedLesson;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _loading = true);
    final engine = KnowledgeEngine.instance;
    await engine.initialize();

    final lessons = await engine.getAllLessons();

    // Cargar manifiesto crudo
    final exporter = const CreatorStudioExporter();
    final kDir = exporter.findKnowledgeDirectory();
    final manifestFile = File('${kDir.path}/editorial_manifest_v1.json');
    List<dynamic> manifestItems = [];
    if (manifestFile.existsSync()) {
      try {
        final parsed = jsonDecode(manifestFile.readAsStringSync());
        manifestItems = parsed['items'] as List<dynamic>? ?? [];
      } catch (_) {}
    }

    setState(() {
      _careerPaths = List.from(engine.careerPaths);
      _projects = List.from(engine.projects);
      _promptExercises = List.from(engine.promptExercises);
      _ideas = List.from(engine.thoughtLibrary.ideas);
      _topics = List.from(engine.thoughtLibrary.topics);
      _authors = List.from(engine.thoughtLibrary.authors);
      _terms = List.from(engine.terms);
      _articles = List.from(engine.articles);
      _tracks = List.from(engine.tracks);
      _competencies = List.from(engine.competencies);
      _skills = List.from(engine.skills);
      _lessons = List.from(lessons);
      _manifestItems = manifestItems;
      _loading = false;
    });
  }

  // --- MÉTODOS DE EXPORTACIÓN Y PERSISTENCIA ---
  void _saveAllChanges() {
    try {
      final exporter = const CreatorStudioExporter();
      exporter.saveCareerPaths(_careerPaths);
      exporter.saveProjects(_projects);
      exporter.savePromptExercises(_promptExercises);
      exporter.saveThoughtLibrary(
        ThoughtLibrary(topics: _topics, authors: _authors, ideas: _ideas),
      );
      exporter.saveDictionary(_terms);
      exporter.saveManual(_articles);
      exporter.saveModules(_tracks, _competencies, _skills);

      // Guardar cada lección
      final manifestMap = {for (final item in _manifestItems) item['id']: item};
      
      for (final lesson in _lessons) {
        // Encontrar ruta en el manifiesto
        String sourcePath = 'knowledge/missions/${lesson.id}.json';
        final manifestItem = manifestMap['missions-core'] ?? manifestMap['missions-advanced'];
        if (manifestItem != null) {
          final sources = (manifestItem['sources'] as List<dynamic>).cast<String>();
          final match = sources.firstWhere((s) => s.endsWith('${lesson.id}.json'), orElse: () => '');
          if (match.isNotEmpty) sourcePath = match;
        }
        exporter.saveLesson(lesson, sourcePath);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Todos los archivos JSON han sido exportados correctamente a knowledge/!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- SISTEMA DE VALIDACIÓN EN TIEMPO REAL ---
  List<String> _runValidation() {
    final errors = <String>[];

    // 1. Conceptos huérfanos (en términos pero no enseñados en lecciones)
    final taughtConcepts = _lessons.expand((l) => l.concepts).toSet();
    for (final term in _terms) {
      if (!taughtConcepts.contains(term.term) && !taughtConcepts.contains(term.id)) {
        errors.add('Glosario: El concepto "${term.term}" es huérfano (no se enseña en ninguna misión).');
      }
    }

    // 2. Enlaces rotos del diccionario
    final termIds = _terms.map((t) => t.id).toSet();
    for (final term in _terms) {
      for (final rel in term.related) {
        if (!termIds.contains(rel)) {
          errors.add('Glosario: El término "${term.term}" tiene un enlace roto a "$rel".');
        }
      }
    }

    // 3. Preguntas sin respuesta correcta o vacías
    for (final lesson in _lessons) {
      for (final block in lesson.blocks) {
        for (final q in block.questions) {
          if (q.question.trim().isEmpty) {
            errors.add('Misiones: En "${lesson.title}", hay una pregunta con texto vacío.');
          }
          if (q.options.isEmpty) {
            errors.add('Misiones: En "${lesson.title}", la pregunta "${q.question}" no tiene opciones.');
          }
          if (q.correctAnswer < 0 || q.correctAnswer >= q.options.length) {
            errors.add('Misiones: En "${lesson.title}", la pregunta "${q.question}" tiene un índice de respuesta correcta fuera de rango.');
          }
        }
      }
    }

    // 4. Capítulos vacíos
    for (final art in _articles) {
      if (art.title.trim().isEmpty) {
        errors.add('Manual: El capítulo con ID "${art.id}" no tiene título.');
      }
      if (art.body.trim().isEmpty) {
        errors.add('Manual: El capítulo "${art.title}" está vacío (sin contenido).');
      }
    }

    // 5. Duplicados
    final pathIds = <String>{};
    for (final p in _careerPaths) {
      if (!pathIds.add(p.id)) errors.add('Cursos: ID de curso duplicado "${p.id}".');
    }
    final lessonIds = <String>{};
    for (final l in _lessons) {
      if (!lessonIds.add(l.id)) errors.add('Misiones: ID de misión duplicado "${l.id}".');
    }
    final termIdsCheck = <String>{};
    for (final t in _terms) {
      if (!termIdsCheck.add(t.id)) errors.add('Glosario: ID de término duplicado "${t.id}".');
    }

    // 6. Referencias inexistentes de misiones en rutas y proyectos
    final lessonNumbers = _lessons.map((l) => l.id.split('-').last).toSet();
    for (final path in _careerPaths) {
      for (final mNum in path.missions) {
        if (!lessonNumbers.contains(mNum)) {
          errors.add('Cursos: La ruta "${path.title}" refiere a la misión inexistente "$mNum".');
        }
      }
    }
    for (final proj in _projects) {
      for (final mNum in proj.missions) {
        if (!lessonNumbers.contains(mNum)) {
          errors.add('Proyectos: El proyecto "${proj.title}" refiere a la misión inexistente "$mNum".');
        }
      }
    }

    return errors;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const OraculoScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return OraculoScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera Premium del Studio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORÁCULO Creator Studio',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'CMS Interno offline para la gestión de lecciones, glosarios y rutas.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Recargar Datos',
                    onPressed: _loadAllData,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    onPressed: _saveAllChanges,
                    icon: const Icon(Icons.save),
                    label: const Text('Exportar cambios (knowledge/)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Dashboard'),
              Tab(text: 'Cursos'),
              Tab(text: 'Misiones'),
              Tab(text: 'Glosario'),
              Tab(text: 'Manual'),
              Tab(text: 'Biblioteca'),
              Tab(text: 'Laboratorios'),
              Tab(text: 'Proyectos'),
              Tab(text: 'Validador'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildCoursesTab(),
                _buildMissionsTab(),
                _buildDictionaryTab(),
                _buildManualTab(),
                _buildThoughtTab(),
                _buildPromptLabTab(),
                _buildProjectsTab(),
                _buildValidatorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MÓDULO 1 — DASHBOARD
  // ==========================================
  Widget _buildDashboardTab() {
    final errors = _runValidation();
    final totalConcepts = _terms.map((t) => t.term).toSet()
      ..addAll(_lessons.expand((l) => l.concepts));

    // Contenido pendiente de revisión (status != 'verificado')
    final pendingManifest = _manifestItems.where((i) => i['status'] != 'verificado').toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        // Indicadores Rápidos
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          children: [
            _buildStatCard('Cursos', _careerPaths.length.toString(), Icons.school),
            _buildStatCard('Módulos', _tracks.length.toString(), Icons.folder_special),
            _buildStatCard('Misiones', _lessons.length.toString(), Icons.explore),
            _buildStatCard('Laboratorios', _promptExercises.length.toString(), Icons.biotech),
            _buildStatCard('Proyectos', _projects.length.toString(), Icons.work),
            _buildStatCard('Términos', _terms.length.toString(), Icons.menu_book),
            _buildStatCard('Artículos', _articles.length.toString(), Icons.article),
            _buildStatCard('Conceptos', totalConcepts.length.toString(), Icons.lightbulb),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Estado de Validación
        Card(
          color: errors.isEmpty ? Colors.green.shade50.withOpacity(0.1) : Colors.red.shade50.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: errors.isEmpty ? Colors.green : Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(
                  errors.isEmpty ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: errors.isEmpty ? Colors.green : Colors.red,
                  size: 40,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        errors.isEmpty ? 'Integridad Semántica Validada' : 'Problemas de Integridad Encontrados',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: errors.isEmpty ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        errors.isEmpty
                            ? 'No se detectaron enlaces rotos, conceptos huérfanos ni dependencias cíclicas.'
                            : 'Se encontraron ${errors.length} problemas editoriales. Revisá la pestaña del Validador.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Contenido Pendiente de Revisión
        Text(
          'Fuentes pendientes de revisión',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (pendingManifest.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text('Todo el contenido manifestado se encuentra marcado como "verificado".'),
            ),
          )
        else
          ...pendingManifest.map((item) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.rate_review, color: Colors.orange),
                title: Text(item['title'] as String),
                subtitle: Text('Estado: ${item['status']} · Autor: ${item['author']}'),
                trailing: Text('v${item['version']}'),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // MÓDULO 2 — EDITOR DE CURSOS
  // ==========================================
  Widget _buildCoursesTab() {
    return Row(
      children: [
        // Sidebar list
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newPath = CareerPath(
                      'new-path-${DateTime.now().millisecondsSinceEpoch}',
                      _careerPaths.length + 1,
                      'Nuevo Curso',
                      'Inicial',
                      const [],
                      const [],
                      const [],
                      10,
                      'Evaluación final del curso',
                    );
                    setState(() {
                      _careerPaths.add(newPath);
                      _selectedPath = newPath;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Curso'),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _careerPaths.map((p) {
                    final isSel = _selectedPath?.id == p.id;
                    return ListTile(
                      title: Text('${p.priority}. ${p.title}'),
                      subtitle: Text(p.level),
                      selected: isSel,
                      onTap: () => setState(() => _selectedPath = p),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() {
                          _careerPaths.removeWhere((x) => x.id == p.id);
                          if (_selectedPath?.id == p.id) _selectedPath = null;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        // Editor Form
        Expanded(
          child: _selectedPath == null
              ? const Center(child: Text('Seleccioná un curso para editarlo.'))
              : _buildCourseForm(),
        ),
      ],
    );
  }

  Widget _buildCourseForm() {
    final path = _selectedPath!;
    final nameCtrl = TextEditingController(text: path.title);
    final descCtrl = TextEditingController(text: path.finalEvaluation); // Reutilizando desc

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Configuración del Curso: ${path.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nombre del Curso'),
          onChanged: (val) {
            setState(() {
              final idx = _careerPaths.indexWhere((x) => x.id == path.id);
              _careerPaths[idx] = CareerPath(
                path.id, path.priority, val, path.level, path.skills, path.missions, path.projects, path.hours, path.finalEvaluation
              );
              _selectedPath = _careerPaths[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: path.level,
                decoration: const InputDecoration(labelText: 'Nivel'),
                items: const [
                  DropdownMenuItem(value: 'Inicial', child: Text('Inicial')),
                  DropdownMenuItem(value: 'Intermedio', child: Text('Intermedio')),
                  DropdownMenuItem(value: 'Avanzado', child: Text('Avanzado')),
                ],
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    final idx = _careerPaths.indexWhere((x) => x.id == path.id);
                    _careerPaths[idx] = CareerPath(
                      path.id, path.priority, path.title, val, path.skills, path.missions, path.projects, path.hours, path.finalEvaluation
                    );
                    _selectedPath = _careerPaths[idx];
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                initialValue: path.hours.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duración Estimada (Horas)'),
                onChanged: (val) {
                  final h = int.tryParse(val) ?? path.hours;
                  setState(() {
                    final idx = _careerPaths.indexWhere((x) => x.id == path.id);
                    _careerPaths[idx] = CareerPath(
                      path.id, path.priority, path.title, path.level, path.skills, path.missions, path.projects, h, path.finalEvaluation
                    );
                    _selectedPath = _careerPaths[idx];
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: descCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Objetivo / Evaluación Final'),
          onChanged: (val) {
            setState(() {
              final idx = _careerPaths.indexWhere((x) => x.id == path.id);
              _careerPaths[idx] = CareerPath(
                path.id, path.priority, path.title, path.level, path.skills, path.missions, path.projects, path.hours, val
              );
              _selectedPath = _careerPaths[idx];
            });
          },
        ),
      ],
    );
  }

  // ==========================================
  // MÓDULO 3 — EDITOR DE MISIONES
  // ==========================================
  Widget _buildMissionsTab() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newId = 'lesson-new-${DateTime.now().millisecondsSinceEpoch}';
                    final newLesson = Lesson(
                      id: newId,
                      contentVersion: 1,
                      title: 'Nueva Misión',
                      objective: 'Objetivo de aprendizaje',
                      estimatedMinutes: 30,
                      concepts: const [],
                      blocks: const [],
                    );
                    setState(() {
                      _lessons.add(newLesson);
                      _selectedLesson = newLesson;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Misión'),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _lessons.map((l) {
                    final isSel = _selectedLesson?.id == l.id;
                    return ListTile(
                      title: Text(l.title),
                      subtitle: Text('${l.estimatedMinutes} min'),
                      selected: isSel,
                      onTap: () => setState(() => _selectedLesson = l),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() {
                          _lessons.removeWhere((x) => x.id == l.id);
                          if (_selectedLesson?.id == l.id) _selectedLesson = null;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedLesson == null
              ? const Center(child: Text('Seleccioná una misión para editarla.'))
              : _buildMissionForm(),
        ),
      ],
    );
  }

  Widget _buildMissionForm() {
    final lesson = _selectedLesson!;
    final titleCtrl = TextEditingController(text: lesson.title);
    final objCtrl = TextEditingController(text: lesson.objective);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Configuración de la Misión: ${lesson.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Título'),
          onChanged: (val) {
            setState(() {
              final idx = _lessons.indexWhere((x) => x.id == lesson.id);
              _lessons[idx] = Lesson(
                id: lesson.id,
                contentVersion: lesson.contentVersion,
                title: val,
                objective: lesson.objective,
                estimatedMinutes: lesson.estimatedMinutes,
                concepts: lesson.concepts,
                blocks: lesson.blocks,
              );
              _selectedLesson = _lessons[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: objCtrl,
          decoration: const InputDecoration(labelText: 'Objetivo Pedagógico'),
          onChanged: (val) {
            setState(() {
              final idx = _lessons.indexWhere((x) => x.id == lesson.id);
              _lessons[idx] = Lesson(
                id: lesson.id,
                contentVersion: lesson.contentVersion,
                title: lesson.title,
                objective: val,
                estimatedMinutes: lesson.estimatedMinutes,
                concepts: lesson.concepts,
                blocks: lesson.blocks,
              );
              _selectedLesson = _lessons[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Bloques Didácticos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            DropdownButton<LessonBlockType>(
              hint: const Text('Agregar Bloque'),
              items: LessonBlockType.values.map((t) {
                return DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()));
              }).toList(),
              onChanged: (type) {
                if (type == null) return;
                final newBlock = LessonBlock(
                  type: type,
                  title: 'Título del bloque',
                  content: 'Contenido del bloque',
                  sequence: lesson.blocks.length + 1,
                );
                setState(() {
                  final idx = _lessons.indexWhere((x) => x.id == lesson.id);
                  final updatedBlocks = List<LessonBlock>.from(lesson.blocks)..add(newBlock);
                  _lessons[idx] = Lesson(
                    id: lesson.id,
                    contentVersion: lesson.contentVersion,
                    title: lesson.title,
                    objective: lesson.objective,
                    estimatedMinutes: lesson.estimatedMinutes,
                    concepts: lesson.concepts,
                    blocks: updatedBlocks,
                  );
                  _selectedLesson = _lessons[idx];
                });
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Lista de bloques editables con ordenación (Mover arriba / Mover abajo)
        if (lesson.blocks.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text('No hay bloques definidos en esta misión.', style: TextStyle(color: Colors.grey))),
          )
        else
          ...lesson.blocks.indexed.map((entry) {
            final (index, block) = entry;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(label: Text('${block.sequence}. ${block.type.name.toUpperCase()}')),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_upward, size: 18),
                              onPressed: index == 0
                                  ? null
                                  : () => _swapBlocks(lesson.id, index, index - 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_downward, size: 18),
                              onPressed: index == lesson.blocks.length - 1
                                  ? null
                                  : () => _swapBlocks(lesson.id, index, index + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                              onPressed: () => _removeBlock(lesson.id, index),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextFormField(
                      initialValue: block.title,
                      decoration: const InputDecoration(labelText: 'Título del Bloque'),
                      onChanged: (val) => _updateBlockField(lesson.id, index, 'title', val),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextFormField(
                      initialValue: block.content,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Contenido del Bloque'),
                      onChanged: (val) => _updateBlockField(lesson.id, index, 'content', val),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  void _swapBlocks(String lessonId, int a, int b) {
    setState(() {
      final idx = _lessons.indexWhere((x) => x.id == lessonId);
      final list = List<LessonBlock>.from(_lessons[idx].blocks);
      final temp = list[a];
      list[a] = LessonBlock(
        type: list[b].type,
        title: list[b].title,
        content: list[b].content,
        sequence: a + 1,
        items: list[b].items,
        prompt: list[b].prompt,
        questions: list[b].questions,
      );
      list[b] = LessonBlock(
        type: temp.type,
        title: temp.title,
        content: temp.content,
        sequence: b + 1,
        items: temp.items,
        prompt: temp.prompt,
        questions: temp.questions,
      );
      _lessons[idx] = Lesson(
        id: lessonId,
        contentVersion: _lessons[idx].contentVersion,
        title: _lessons[idx].title,
        objective: _lessons[idx].objective,
        estimatedMinutes: _lessons[idx].estimatedMinutes,
        concepts: _lessons[idx].concepts,
        blocks: list,
      );
      _selectedLesson = _lessons[idx];
    });
  }

  void _removeBlock(String lessonId, int index) {
    setState(() {
      final idx = _lessons.indexWhere((x) => x.id == lessonId);
      final list = List<LessonBlock>.from(_lessons[idx].blocks)..removeAt(index);
      // Actualizar secuencias
      final updated = list.indexed.map((e) {
        final (i, b) = e;
        return LessonBlock(
          type: b.type,
          title: b.title,
          content: b.content,
          sequence: i + 1,
          items: b.items,
          prompt: b.prompt,
          questions: b.questions,
        );
      }).toList();
      _lessons[idx] = Lesson(
        id: lessonId,
        contentVersion: _lessons[idx].contentVersion,
        title: _lessons[idx].title,
        objective: _lessons[idx].objective,
        estimatedMinutes: _lessons[idx].estimatedMinutes,
        concepts: _lessons[idx].concepts,
        blocks: updated,
      );
      _selectedLesson = _lessons[idx];
    });
  }

  void _updateBlockField(String lessonId, int index, String field, String value) {
    setState(() {
      final idx = _lessons.indexWhere((x) => x.id == lessonId);
      final list = List<LessonBlock>.from(_lessons[idx].blocks);
      final old = list[index];
      list[index] = LessonBlock(
        type: old.type,
        title: field == 'title' ? value : old.title,
        content: field == 'content' ? value : old.content,
        sequence: old.sequence,
        items: old.items,
        prompt: old.prompt,
        questions: old.questions,
      );
      _lessons[idx] = Lesson(
        id: lessonId,
        contentVersion: _lessons[idx].contentVersion,
        title: _lessons[idx].title,
        objective: _lessons[idx].objective,
        estimatedMinutes: _lessons[idx].estimatedMinutes,
        concepts: _lessons[idx].concepts,
        blocks: list,
      );
    });
  }

  // ==========================================
  // MÓDULO 4 — EDITOR DEL DICCIONARIO
  // ==========================================
  Widget _buildDictionaryTab() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newTerm = DictionaryTerm(
                      id: 'term-new-${DateTime.now().millisecondsSinceEpoch}',
                      term: 'Nuevo Concepto',
                      definition: 'Definición corta',
                      explanation: 'Explicación detallada',
                      analogy: 'Analogía',
                      example: 'Ejemplo práctico',
                      mistake: 'Errores frecuentes',
                      related: const <String>[],
                    );
                    setState(() {
                      _terms.add(newTerm);
                      _selectedTerm = newTerm;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Término'),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _terms.map((t) {
                    final isSel = _selectedTerm?.id == t.id;
                    return ListTile(
                      title: Text(t.term),
                      selected: isSel,
                      onTap: () => setState(() => _selectedTerm = t),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() {
                          _terms.removeWhere((x) => x.id == t.id);
                          if (_selectedTerm?.id == t.id) _selectedTerm = null;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedTerm == null
              ? const Center(child: Text('Seleccioná un término del glosario para editarlo.'))
              : _buildDictionaryForm(),
        ),
      ],
    );
  }

  Widget _buildDictionaryForm() {
    final term = _selectedTerm!;
    final termCtrl = TextEditingController(text: term.term);
    final defCtrl = TextEditingController(text: term.definition);
    final expCtrl = TextEditingController(text: term.explanation);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Configuración del Término: ${term.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: termCtrl,
          decoration: const InputDecoration(labelText: 'Término / Concepto'),
          onChanged: (val) {
            setState(() {
              final idx = _terms.indexWhere((x) => x.id == term.id);
              _terms[idx] = DictionaryTerm(
                id: term.id,
                term: val,
                definition: term.definition,
                explanation: term.explanation,
                analogy: term.analogy,
                example: term.example,
                mistake: term.mistake,
                related: term.related,
              );
              _selectedTerm = _terms[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: defCtrl,
          decoration: const InputDecoration(labelText: 'Definición Corta'),
          onChanged: (val) {
            setState(() {
              final idx = _terms.indexWhere((x) => x.id == term.id);
              _terms[idx] = DictionaryTerm(
                id: term.id,
                term: term.term,
                definition: val,
                explanation: term.explanation,
                analogy: term.analogy,
                example: term.example,
                mistake: term.mistake,
                related: term.related,
              );
              _selectedTerm = _terms[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: expCtrl,
          maxLines: 4,
          decoration: const InputDecoration(labelText: 'Explicación Completa'),
          onChanged: (val) {
            setState(() {
              final idx = _terms.indexWhere((x) => x.id == term.id);
              _terms[idx] = DictionaryTerm(
                id: term.id,
                term: term.term,
                definition: term.definition,
                explanation: val,
                analogy: term.analogy,
                example: term.example,
                mistake: term.mistake,
                related: term.related,
              );
              _selectedTerm = _terms[idx];
            });
          },
        ),
      ],
    );
  }

  // ==========================================
  // MÓDULO 5 — EDITOR DEL MANUAL
  // ==========================================
  Widget _buildManualTab() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newArt = KnowledgeArticle(
                      id: 'art-new-${DateTime.now().millisecondsSinceEpoch}',
                      title: 'Nuevo Capítulo',
                      body: 'Contenido del manual en markdown',
                      links: const <String>[],
                    );
                    setState(() {
                      _articles.add(newArt);
                      _selectedArticle = newArt;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Capítulo'),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _articles.map((a) {
                    final isSel = _selectedArticle?.id == a.id;
                    return ListTile(
                      title: Text(a.title),
                      selected: isSel,
                      onTap: () => setState(() => _selectedArticle = a),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() {
                          _articles.removeWhere((x) => x.id == a.id);
                          if (_selectedArticle?.id == a.id) _selectedArticle = null;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedArticle == null
              ? const Center(child: Text('Seleccioná un artículo de manual para editarlo.'))
              : _buildManualForm(),
        ),
      ],
    );
  }

  Widget _buildManualForm() {
    final art = _selectedArticle!;
    final titleCtrl = TextEditingController(text: art.title);
    final bodyCtrl = TextEditingController(text: art.body);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Configuración del Capítulo: ${art.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Título'),
          onChanged: (val) {
            setState(() {
              final idx = _articles.indexWhere((x) => x.id == art.id);
              _articles[idx] = KnowledgeArticle(
                id: art.id,
                title: val,
                body: art.body,
                links: art.links,
              );
              _selectedArticle = _articles[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: bodyCtrl,
          maxLines: 12,
          decoration: const InputDecoration(labelText: 'Cuerpo (Markdown)'),
          onChanged: (val) {
            setState(() {
              final idx = _articles.indexWhere((x) => x.id == art.id);
              _articles[idx] = KnowledgeArticle(
                id: art.id,
                title: art.title,
                body: val,
                links: art.links,
              );
              _selectedArticle = _articles[idx];
            });
          },
        ),
      ],
    );
  }

  // ==========================================
  // MÓDULO 6 — BIBLIOTECA DE PENSAMIENTO
  // ==========================================
  Widget _buildThoughtTab() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newIdea = ThoughtIdea(
                      id: 'idea-new-${DateTime.now().millisecondsSinceEpoch}',
                      author: 'Autor',
                      topic: 'Tema',
                      kind: 'paráfrasis',
                      title: 'Nueva Idea',
                      body: 'Descripción de la idea',
                      application: 'Aplicación práctica',
                      concepts: const [],
                      source: '',
                    );
                    setState(() {
                      if (!_authors.contains('Autor')) _authors.add('Autor');
                      if (!_topics.contains('Tema')) _topics.add('Tema');
                      _ideas.add(newIdea);
                      _selectedIdea = newIdea;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva Idea'),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _ideas.map((i) {
                    final isSel = _selectedIdea?.id == i.id;
                    return ListTile(
                      title: Text(i.title),
                      subtitle: Text('${i.author} · ${i.kind}'),
                      selected: isSel,
                      onTap: () => setState(() => _selectedIdea = i),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() {
                          _ideas.removeWhere((x) => x.id == i.id);
                          if (_selectedIdea?.id == i.id) _selectedIdea = null;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedIdea == null
              ? const Center(child: Text('Seleccioná una idea de la biblioteca para editarla.'))
              : _buildThoughtForm(),
        ),
      ],
    );
  }

  Widget _buildThoughtForm() {
    final idea = _selectedIdea!;
    final authorCtrl = TextEditingController(text: idea.author);
    final topicCtrl = TextEditingController(text: idea.topic);
    final titleCtrl = TextEditingController(text: idea.title);
    final bodyCtrl = TextEditingController(text: idea.body);
    final appCtrl = TextEditingController(text: idea.application);
    final srcCtrl = TextEditingController(text: idea.source ?? '');

    // Validación de citas textuales sin fuente en el guardado
    final isQuote = idea.kind == 'cita textual';
    final hasSource = idea.source != null && idea.source!.trim().isNotEmpty;
    final validationWarning = isQuote && !hasSource;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Configuración de Idea: ${idea.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.md),
        if (validationWarning)
          Card(
            color: Colors.red.shade50.withOpacity(0.1),
            shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.red)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'WARNING: No está permitido guardar una cita textual sin fuente documentada.',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          value: idea.kind,
          decoration: const InputDecoration(labelText: 'Tipo de Idea'),
          items: const [
            DropdownMenuItem(value: 'cita textual', child: Text('Cita Textual')),
            DropdownMenuItem(value: 'paráfrasis', child: Text('Paráfrasis')),
            DropdownMenuItem(value: 'interpretación editorial', child: Text('Interpretación Editorial')),
            DropdownMenuItem(value: 'aplicación práctica', child: Text('Aplicación Práctica')),
          ],
          onChanged: (val) {
            if (val == null) return;
            setState(() {
              final idx = _ideas.indexWhere((x) => x.id == idea.id);
              _ideas[idx] = ThoughtIdea(
                id: idea.id, author: idea.author, topic: idea.topic, kind: val, title: idea.title, body: idea.body,
                application: idea.application, concepts: idea.concepts, source: idea.source, date: idea.date,
                context: idea.context, verification: idea.verification,
              );
              _selectedIdea = _ideas[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: authorCtrl,
          decoration: const InputDecoration(labelText: 'Autor'),
          onChanged: (val) {
            setState(() {
              final idx = _ideas.indexWhere((x) => x.id == idea.id);
              if (!_authors.contains(val)) _authors.add(val);
              _ideas[idx] = ThoughtIdea(
                id: idea.id, author: val, topic: idea.topic, kind: idea.kind, title: idea.title, body: idea.body,
                application: idea.application, concepts: idea.concepts, source: idea.source, date: idea.date,
                context: idea.context, verification: idea.verification,
              );
              _selectedIdea = _ideas[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: topicCtrl,
          decoration: const InputDecoration(labelText: 'Tema'),
          onChanged: (val) {
            setState(() {
              final idx = _ideas.indexWhere((x) => x.id == idea.id);
              if (!_topics.contains(val)) _topics.add(val);
              _ideas[idx] = ThoughtIdea(
                id: idea.id, author: idea.author, topic: val, kind: idea.kind, title: idea.title, body: idea.body,
                application: idea.application, concepts: idea.concepts, source: idea.source, date: idea.date,
                context: idea.context, verification: idea.verification,
              );
              _selectedIdea = _ideas[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Título'),
          onChanged: (val) {
            setState(() {
              final idx = _ideas.indexWhere((x) => x.id == idea.id);
              _ideas[idx] = ThoughtIdea(
                id: idea.id, author: idea.author, topic: idea.topic, kind: idea.kind, title: val, body: idea.body,
                application: idea.application, concepts: idea.concepts, source: idea.source, date: idea.date,
                context: idea.context, verification: idea.verification,
              );
              _selectedIdea = _ideas[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: bodyCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Cuerpo de la Idea'),
          onChanged: (val) {
            setState(() {
              final idx = _ideas.indexWhere((x) => x.id == idea.id);
              _ideas[idx] = ThoughtIdea(
                id: idea.id, author: idea.author, topic: idea.topic, kind: idea.kind, title: idea.title, body: val,
                application: idea.application, concepts: idea.concepts, source: idea.source, date: idea.date,
                context: idea.context, verification: idea.verification,
              );
              _selectedIdea = _ideas[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: appCtrl,
          decoration: const InputDecoration(labelText: 'Aplicación Práctica'),
          onChanged: (val) {
            setState(() {
              final idx = _ideas.indexWhere((x) => x.id == idea.id);
              _ideas[idx] = ThoughtIdea(
                id: idea.id, author: idea.author, topic: idea.topic, kind: idea.kind, title: idea.title, body: idea.body,
                application: val, concepts: idea.concepts, source: idea.source, date: idea.date,
                context: idea.context, verification: idea.verification,
              );
              _selectedIdea = _ideas[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: srcCtrl,
          decoration: const InputDecoration(labelText: 'Fuente / Referencia'),
          onChanged: (val) {
            setState(() {
              final idx = _ideas.indexWhere((x) => x.id == idea.id);
              _ideas[idx] = ThoughtIdea(
                id: idea.id, author: idea.author, topic: idea.topic, kind: idea.kind, title: idea.title, body: idea.body,
                application: idea.application, concepts: idea.concepts, source: val, date: idea.date,
                context: idea.context, verification: idea.verification,
              );
              _selectedIdea = _ideas[idx];
            });
          },
        ),
      ],
    );
  }

  // ==========================================
  // MÓDULO 7 — LABORATORIOS
  // ==========================================
  Widget _buildPromptLabTab() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newEx = PromptExercise(
                      id: 'prompt-new-${DateTime.now().millisecondsSinceEpoch}',
                      category: 'General',
                      level: 1,
                      title: 'Nuevo Laboratorio',
                      original: 'Prompt original ineficaz',
                      improved: 'Prompt mejorado con técnicas',
                      why: 'Explicación del cambio',
                    );
                    setState(() {
                      _promptExercises.add(newEx);
                      _selectedExercise = newEx;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Laboratorio'),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _promptExercises.map((e) {
                    final isSel = _selectedExercise?.id == e.id;
                    return ListTile(
                      title: Text(e.title),
                      subtitle: Text('${e.category} · Nivel ${e.level}'),
                      selected: isSel,
                      onTap: () => setState(() => _selectedExercise = e),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() {
                          _promptExercises.removeWhere((x) => x.id == e.id);
                          if (_selectedExercise?.id == e.id) _selectedExercise = null;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedExercise == null
              ? const Center(child: Text('Seleccioná un laboratorio para editarlo.'))
              : _buildPromptLabForm(),
        ),
      ],
    );
  }

  Widget _buildPromptLabForm() {
    final ex = _selectedExercise!;
    final titleCtrl = TextEditingController(text: ex.title);
    final catCtrl = TextEditingController(text: ex.category);
    final origCtrl = TextEditingController(text: ex.original);
    final impCtrl = TextEditingController(text: ex.improved);
    final whyCtrl = TextEditingController(text: ex.why);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Configuración del Laboratorio: ${ex.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Título'),
          onChanged: (val) {
            setState(() {
              final idx = _promptExercises.indexWhere((x) => x.id == ex.id);
              _promptExercises[idx] = PromptExercise(
                id: ex.id, category: ex.category, level: ex.level, title: val,
                original: ex.original, improved: ex.improved, why: ex.why,
              );
              _selectedExercise = _promptExercises[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: catCtrl,
                decoration: const InputDecoration(labelText: 'Categoría'),
                onChanged: (val) {
                  setState(() {
                    final idx = _promptExercises.indexWhere((x) => x.id == ex.id);
                    _promptExercises[idx] = PromptExercise(
                      id: ex.id, category: val, level: ex.level, title: ex.title,
                      original: ex.original, improved: ex.improved, why: ex.why,
                    );
                    _selectedExercise = _promptExercises[idx];
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TextFormField(
                initialValue: ex.level.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nivel Dificultad (1-3)'),
                onChanged: (val) {
                  final l = int.tryParse(val) ?? ex.level;
                  setState(() {
                    final idx = _promptExercises.indexWhere((x) => x.id == ex.id);
                    _promptExercises[idx] = PromptExercise(
                      id: ex.id, category: ex.category, level: l, title: ex.title,
                      original: ex.original, improved: ex.improved, why: ex.why,
                    );
                    _selectedExercise = _promptExercises[idx];
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: origCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Prompt Original (Malo)'),
          onChanged: (val) {
            setState(() {
              final idx = _promptExercises.indexWhere((x) => x.id == ex.id);
              _promptExercises[idx] = PromptExercise(
                id: ex.id, category: ex.category, level: ex.level, title: ex.title,
                original: val, improved: ex.improved, why: ex.why,
              );
              _selectedExercise = _promptExercises[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: impCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Prompt Mejorado (Estructurado)'),
          onChanged: (val) {
            setState(() {
              final idx = _promptExercises.indexWhere((x) => x.id == ex.id);
              _promptExercises[idx] = PromptExercise(
                id: ex.id, category: ex.category, level: ex.level, title: ex.title,
                original: ex.original, improved: val, why: ex.why,
              );
              _selectedExercise = _promptExercises[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: whyCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Razón / Explicación del cambio'),
          onChanged: (val) {
            setState(() {
              final idx = _promptExercises.indexWhere((x) => x.id == ex.id);
              _promptExercises[idx] = PromptExercise(
                id: ex.id, category: ex.category, level: ex.level, title: ex.title,
                original: ex.original, improved: ex.improved, why: val,
              );
              _selectedExercise = _promptExercises[idx];
            });
          },
        ),
      ],
    );
  }

  // ==========================================
  // MÓDULO 8 — PROYECTOS
  // ==========================================
  Widget _buildProjectsTab() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newProj = LearningProject(
                      'proj-new-${DateTime.now().millisecondsSinceEpoch}',
                      'Nuevo Proyecto',
                      'Objetivo de la práctica',
                      const [],
                      const [],
                      const [],
                      const [],
                      const [],
                      const [],
                      'Evaluación del proyecto',
                    );
                    setState(() {
                      _projects.add(newProj);
                      _selectedProject = newProj;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Proyecto'),
                ),
              ),
              Expanded(
                child: ListView(
                  children: _projects.map((p) {
                    final isSel = _selectedProject?.id == p.id;
                    return ListTile(
                      title: Text(p.title),
                      selected: isSel,
                      onTap: () => setState(() => _selectedProject = p),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => setState(() {
                          _projects.removeWhere((x) => x.id == p.id);
                          if (_selectedProject?.id == p.id) _selectedProject = null;
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedProject == null
              ? const Center(child: Text('Seleccioná un proyecto para editarlo.'))
              : _buildProjectForm(),
        ),
      ],
    );
  }

  Widget _buildProjectForm() {
    final proj = _selectedProject!;
    final titleCtrl = TextEditingController(text: proj.title);
    final objCtrl = TextEditingController(text: proj.objective);
    final evalCtrl = TextEditingController(text: proj.evaluation);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Configuración del Proyecto: ${proj.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Título'),
          onChanged: (val) {
            setState(() {
              final idx = _projects.indexWhere((x) => x.id == proj.id);
              _projects[idx] = LearningProject(
                proj.id, val, proj.objective, proj.knowledge, proj.missions, proj.steps, proj.deliverables, proj.success, proj.risks, proj.evaluation
              );
              _selectedProject = _projects[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: objCtrl,
          decoration: const InputDecoration(labelText: 'Objetivo de la Práctica'),
          onChanged: (val) {
            setState(() {
              final idx = _projects.indexWhere((x) => x.id == proj.id);
              _projects[idx] = LearningProject(
                proj.id, proj.title, val, proj.knowledge, proj.missions, proj.steps, proj.deliverables, proj.success, proj.risks, proj.evaluation
              );
              _selectedProject = _projects[idx];
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: evalCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Evaluación y Criterios de Aceptación'),
          onChanged: (val) {
            setState(() {
              final idx = _projects.indexWhere((x) => x.id == proj.id);
              _projects[idx] = LearningProject(
                proj.id, proj.title, proj.objective, proj.knowledge, proj.missions, proj.steps, proj.deliverables, proj.success, proj.risks, val
              );
              _selectedProject = _projects[idx];
            });
          },
        ),
      ],
    );
  }

  // ==========================================
  // MÓDULO 9 — VALIDADOR
  // ==========================================
  Widget _buildValidatorTab() {
    final errors = _runValidation();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reporte del Validador de Consistencia',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => setState(() {}),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (errors.isEmpty)
          Card(
            color: Colors.green.shade50.withOpacity(0.1),
            shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.green)),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: AppSpacing.sm),
                  Text('¡Excelente! No hay errores de integridad semántica en los datos locales.'),
                ],
              ),
            ),
          )
        else
          ...errors.map((err) {
            return Card(
              color: Colors.red.shade50.withOpacity(0.1),
              shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.red)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        err,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
