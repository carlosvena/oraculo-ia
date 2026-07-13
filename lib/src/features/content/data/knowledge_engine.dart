import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:oraculo_ia/src/features/career/domain/career_path.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/model_comparator/domain/model_profile.dart';
import 'package:oraculo_ia/src/features/projects/domain/learning_project.dart';
import 'package:oraculo_ia/src/features/prompt_lab/domain/prompt_exercise.dart';
import 'package:oraculo_ia/src/features/thought_library/domain/thought_library.dart';
import 'package:oraculo_ia/src/modules/academy/competency.dart';
import 'package:oraculo_ia/src/modules/academy/skill.dart';
import 'package:oraculo_ia/src/modules/academy/track.dart';

/// Motor de contenido offline de ORÁCULO IA.
///
/// Encapsula la carga asíncrona, validación de integridad editorial, caché en memoria
/// y lazy-loading para permitir el soporte de miles de lecciones.
final class KnowledgeEngine {
  KnowledgeEngine._();
  static final instance = KnowledgeEngine._();

  // Cachés en memoria
  bool _initialized = false;
  late final List<EditorialManifestItem> _manifestItems;
  final _lessonsCache = <String, Lesson>{};
  final _lessonsMetadata = <String, LessonMetadata>{};
  final _articles = <KnowledgeArticle>[];
  final _terms = <DictionaryTerm>[];

  final _careerPaths = <CareerPath>[];
  final _projects = <LearningProject>[];
  final _promptExercises = <PromptExercise>[];
  late final ThoughtLibrary _thoughtLibrary;
  final _modelCatalog = <ModelProfile>[];
  final _tracks = <Track>[];
  final _competencies = <Competency>[];
  final _skills = <Skill>[];

  // Getters expuestos
  bool get isInitialized => _initialized;
  List<KnowledgeArticle> get articles => List.unmodifiable(_articles);
  List<DictionaryTerm> get terms => List.unmodifiable(_terms);
  List<CareerPath> get careerPaths => List.unmodifiable(_careerPaths);
  List<LearningProject> get projects => List.unmodifiable(_projects);
  List<PromptExercise> get promptExercises => List.unmodifiable(_promptExercises);
  ThoughtLibrary get thoughtLibrary => _thoughtLibrary;
  List<ModelProfile> get modelCatalog => List.unmodifiable(_modelCatalog);
  List<Track> get tracks => List.unmodifiable(_tracks);
  List<Competency> get competencies => List.unmodifiable(_competencies);
  List<Skill> get skills => List.unmodifiable(_skills);

  /// Inicializa el motor cargando el manifiesto y los metadatos de las lecciones
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 1. Cargar editorial_manifest_v1.json
      final manifestJson = await rootBundle.loadString('knowledge/editorial_manifest_v1.json');
      _manifestItems = _parseManifest(manifestJson);

      // 2. Cargar diccionario, manual y taxonomías
      await _loadDictionary();
      await _loadManual();
      await _loadMissionsMetadata();

      // 3. Cargar el resto de contenidos curriculares y de práctica
      await _loadCareerPaths();
      await _loadProjects();
      await _loadPromptExercises();
      await _loadThoughtLibrary();
      await _loadModelCatalog();
      await _loadModules();

      // 4. Validar integridad semántica (relaciones, ciclos de prerrequisitos)
      _validateIntegrity();

      _initialized = true;
    } catch (e) {
      throw EditorialContentException('Fallo al inicializar KnowledgeEngine: $e');
    }
  }

  /// Retorna la lección completa, cargándola de disco si no está en caché (lazy loading)
  Future<Lesson> getLesson(String id) async {
    await initialize();

    if (_lessonsCache.containsKey(id)) {
      return _lessonsCache[id]!;
    }

    final metadata = _lessonsMetadata[id];
    if (metadata == null) {
      throw EditorialContentException('La misión "$id" no existe en los metadatos.');
    }

    try {
      final jsonStr = await rootBundle.loadString(metadata.sourcePath);
      final lesson = _parseFullLesson(jsonStr, metadata.sourcePath);
      _lessonsCache[id] = lesson;
      return lesson;
    } catch (e) {
      throw EditorialContentException('Error al cargar la lección $id desde ${metadata.sourcePath}: $e');
    }
  }

  /// Obtiene todos los encabezados de las lecciones ordenadas
  Future<List<Lesson>> getAllLessons() async {
    await initialize();
    final results = <Lesson>[];
    for (final id in _lessonsMetadata.keys) {
      results.add(await getLesson(id));
    }
    return results;
  }

  /// Búsqueda rápida sobre el manual
  List<KnowledgeArticle> searchArticles(String query) {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) return _articles;
    return _articles
        .where((a) => '${a.title} ${a.body}'.toLowerCase().contains(value))
        .toList();
  }

  /// Obtiene un término del diccionario por su ID
  DictionaryTerm getTerm(String id) {
    return _terms.firstWhere(
      (item) => item.id == id,
      orElse: () => throw EditorialContentException('El término "$id" no existe en el diccionario.'),
    );
  }

  // --- PARSERS INTERNOS ---

  List<EditorialManifestItem> _parseManifest(String source) {
    final root = jsonDecode(source);
    if (root is! Map<String, dynamic> || root['schemaVersion'] != 1) {
      throw const EditorialContentException('schemaVersion de manifiesto ausente o incompatible.');
    }
    final items = root['items'] as List<dynamic>? ?? const [];
    return items.map((e) {
      final m = e as Map<String, dynamic>;
      return EditorialManifestItem(
        id: m['id'] as String,
        title: m['title'] as String,
        sources: (m['sources'] as List<dynamic>).cast<String>(),
      );
    }).toList();
  }

  Future<void> _loadDictionary() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'dictionary');
    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de diccionario incompatible en $source');
      }
      final list = root['dictionary'] as List<dynamic>;
      for (final termMap in list.cast<Map<String, dynamic>>()) {
        _terms.add(
          DictionaryTerm(
            id: termMap['id'] as String,
            term: termMap['term'] as String,
            definition: termMap['definition'] as String,
            explanation: termMap['explanation'] as String,
            analogy: termMap['analogy'] as String,
            example: termMap['example'] as String,
            mistake: termMap['mistake'] as String,
            related: (termMap['related'] as List<dynamic>).cast<String>(),
          ),
        );
      }
    }
  }

  Future<void> _loadManual() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'manual');
    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de manual incompatible en $source');
      }
      final list = root['articles'] as List<dynamic>;
      for (final artMap in list.cast<Map<String, dynamic>>()) {
        _articles.add(
          KnowledgeArticle(
            id: artMap['id'] as String,
            title: artMap['title'] as String,
            body: artMap['body'] as String,
            links: (artMap['links'] as List<dynamic>).cast<String>(),
          ),
        );
      }
    }
  }

  Future<void> _loadMissionsMetadata() async {
    final coreItem = _manifestItems.firstWhere((i) => i.id == 'missions-core');
    final advItem = _manifestItems.firstWhere((i) => i.id == 'missions-advanced');

    final allMissionsSources = [...coreItem.sources, ...advItem.sources];
    for (final source in allMissionsSources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de lección incompatible en $source');
      }
      final m = root['mission'] as Map<String, dynamic>;
      final id = m['id'] as String;
      final title = m['title'] as String;
      final duration = m['duration'] as int;
      final concepts = (m['concepts'] as List<dynamic>).cast<String>();
      final prerequisites = (m['prerequisiteIds'] as List<dynamic>? ?? const []).cast<String>();

      _lessonsMetadata[id] = LessonMetadata(
        id: id,
        title: title,
        duration: duration,
        concepts: concepts,
        prerequisites: prerequisites,
        sourcePath: source,
      );
    }
  }

  Future<void> _loadCareerPaths() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'courses');
    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de caminos profesionales incompatible en $source');
      }
      final list = root['paths'] as List<dynamic>;
      for (final p in list.cast<Map<String, dynamic>>()) {
        List<String> getStringList(String k) => (p[k] as List<dynamic>).cast<String>();
        _careerPaths.add(
          CareerPath(
            p['id'] as String,
            p['priority'] as int,
            p['title'] as String,
            p['level'] as String,
            getStringList('skills'),
            getStringList('missions'),
            getStringList('projects'),
            p['hours'] as int,
            p['final'] as String,
          ),
        );
      }
    }
    _careerPaths.sort((a, b) => a.priority.compareTo(b.priority));
  }

  Future<void> _loadProjects() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'projects');
    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de proyectos incompatible en $source');
      }
      final list = root['projects'] as List<dynamic>;
      for (final p in list.cast<Map<String, dynamic>>()) {
        List<String> getStringList(String k) => (p[k] as List<dynamic>).cast<String>();
        _projects.add(
          LearningProject(
            p['id'] as String,
            p['title'] as String,
            p['objective'] as String,
            getStringList('knowledge'),
            getStringList('missions'),
            getStringList('steps'),
            getStringList('deliverables'),
            getStringList('success'),
            getStringList('risks'),
            p['evaluation'] as String,
          ),
        );
      }
    }
  }

  Future<void> _loadPromptExercises() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'prompt-exercises');
    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de ejercicios de prompt incompatible en $source');
      }
      final list = root['exercises'] as List<dynamic>;
      for (final e in list.cast<Map<String, dynamic>>()) {
        _promptExercises.add(
          PromptExercise(
            id: e['id'] as String,
            category: e['category'] as String,
            level: e['level'] as int,
            title: e['title'] as String,
            original: e['original'] as String,
            improved: e['improved'] as String,
            why: e['why'] as String,
          ),
        );
      }
    }
  }

  Future<void> _loadThoughtLibrary() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'thought-library');
    final allTopics = <String>{};
    final allAuthors = <String>{};
    final allIdeas = <ThoughtIdea>[];

    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de biblioteca de pensamiento incompatible en $source');
      }
      final topics = (root['topics'] as List<dynamic>).cast<String>();
      final authors = (root['authors'] as List<dynamic>).cast<String>();
      allTopics.addAll(topics);
      allAuthors.addAll(authors);

      final ideasList = root['ideas'] as List<dynamic>;
      for (final itemMap in ideasList.cast<Map<String, dynamic>>()) {
        String text(String key) {
          final val = itemMap[key];
          if (val is! String || val.isEmpty) {
            throw const ThoughtLibraryException('Falta variable en idea de biblioteca.');
          }
          return val;
        }

        final author = text('author');
        final topic = text('topic');
        final kind = text('kind');
        if (!authors.contains(author) || !topics.contains(topic)) {
          throw const ThoughtLibraryException('Autor o tema no de biblioteca.');
        }
        if (!const [
          'cita textual',
          'paráfrasis',
          'interpretación editorial',
          'aplicación práctica',
        ].contains(kind)) {
          throw const ThoughtLibraryException('Tipo editorial inválido.');
        }

        allIdeas.add(
          ThoughtIdea(
            id: text('id'),
            author: author,
            topic: topic,
            kind: kind,
            title: text('title'),
            body: text('body'),
            application: text('application'),
            concepts: (itemMap['concepts'] as List<dynamic>).cast<String>(),
            source: itemMap['source'] as String?,
            date: itemMap['date'] as String?,
            context: itemMap['context'] as String?,
            verification: itemMap['verification'] as String?,
          ),
        );
      }
    }
    _thoughtLibrary = ThoughtLibrary(
      topics: allTopics.toList(),
      authors: allAuthors.toList(),
      ideas: allIdeas,
    );
  }

  Future<void> _loadModelCatalog() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'model-catalog');
    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de catálogo de modelos incompatible en $source');
      }
      final list = root['models'] as List<dynamic>;
      for (final itemMap in list.cast<Map<String, dynamic>>()) {
        String text(String key) => itemMap[key] as String;
        List<String> getStrList(String key) => (itemMap[key] as List<dynamic>).cast<String>();
        _modelCatalog.add(
          ModelProfile(
            id: text('id'),
            name: text('name'),
            what: text('what'),
            strengths: getStrList('strengths'),
            limits: getStrList('limits'),
            uses: getStrList('uses'),
            avoid: text('avoid'),
            privacy: text('privacy'),
            availability: text('availability'),
            related: getStrList('related'),
            source: text('source'),
            verified: itemMap['verified'] as bool,
          ),
        );
      }
    }
  }

  Future<void> _loadModules() async {
    final item = _manifestItems.firstWhere((i) => i.id == 'modules');
    for (final source in item.sources) {
      final jsonStr = await rootBundle.loadString(source);
      final root = jsonDecode(jsonStr) as Map<String, dynamic>;
      if (root['schemaVersion'] != 1) {
        throw EditorialContentException('Esquema de módulos incompatible en $source');
      }

      final skillsList = root['skills'] as List<dynamic>? ?? const [];
      for (final s in skillsList.cast<Map<String, dynamic>>()) {
        _skills.add(
          Skill(
            id: s['id'] as String,
            name: s['name'] as String,
            description: s['description'] as String,
            tags: (s['tags'] as List<dynamic>).cast<String>().toSet(),
          ),
        );
      }

      final competenciesList = root['competencies'] as List<dynamic>? ?? const [];
      for (final c in competenciesList.cast<Map<String, dynamic>>()) {
        final levelStr = c['targetLevel'] as String;
        final targetLevel = CompetencyLevel.values.firstWhere(
          (item) => item.name == levelStr.toLowerCase(),
          orElse: () => CompetencyLevel.foundational,
        );
        _competencies.add(
          Competency(
            id: c['id'] as String,
            name: c['name'] as String,
            description: c['description'] as String,
            skillIds: (c['skillIds'] as List<dynamic>).cast<String>().toSet(),
            targetLevel: targetLevel,
          ),
        );
      }

      final tracksList = root['tracks'] as List<dynamic>? ?? const [];
      for (final t in tracksList.cast<Map<String, dynamic>>()) {
        _tracks.add(
          Track(
            id: t['id'] as String,
            name: t['name'] as String,
            description: t['description'] as String,
            competencyIds: (t['competencyIds'] as List<dynamic>).cast<String>().toSet(),
            missionSequenceIds: (t['missionSequenceIds'] as List<dynamic>).cast<String>(),
          ),
        );
      }
    }
  }

  Lesson _parseFullLesson(String source, String path) {
    final root = jsonDecode(source) as Map<String, dynamic>;
    final m = root['mission'] as Map<String, dynamic>;
    final id = m['id'] as String;
    final title = m['title'] as String;
    final objective = m['objective'] as String;
    final duration = m['duration'] as int;
    final concepts = (m['concepts'] as List<dynamic>).cast<String>();
    final contentVersion = m['version'] as int? ?? 1;

    final blocks = <LessonBlock>[];

    if (m.containsKey('blocks')) {
      final list = m['blocks'] as List<dynamic>;
      for (final (index, blockRaw) in list.indexed) {
        final b = blockRaw as Map<String, dynamic>;
        final typeName = b['type'] as String;
        final type = LessonBlockType.values.firstWhere(
          (item) => item.name == typeName,
          orElse: () => throw EditorialContentException('Tipo de bloque desconocido: $typeName.'),
        );
        final questions = (b['questions'] as List<dynamic>? ?? const []).map((qRaw) {
          final q = qRaw as Map<String, dynamic>;
          final options = (q['options'] as List<dynamic>).cast<String>();
          final correct = q['correct'] as int;
          if (correct < 0 || correct >= options.length) {
            throw EditorialContentException('Respuesta correcta inválida en ${q['question']}.');
          }
          return LessonQuestion(
            question: q['question'] as String,
            options: options,
            correctAnswer: correct,
            explanation: q['explanation'] as String,
          );
        }).toList();

        blocks.add(
          LessonBlock(
            type: type,
            title: b['title'] as String,
            content: b['content'] as String,
            sequence: index + 1,
            items: (b['items'] as List<dynamic>? ?? const []).cast<String>(),
            prompt: b['prompt'] as String?,
            questions: questions,
          ),
        );
      }
    } else if (m.containsKey('sections') && m.containsKey('quiz')) {
      final sections = m['sections'] as List<dynamic>;
      final quiz = m['quiz'] as List<dynamic>;

      if (sections.length < 10) {
        throw EditorialContentException('$id debe tener al menos 10 bloques.');
      }
      if (quiz.length < 8) {
        throw EditorialContentException('$id debe tener al menos 8 preguntas.');
      }

      for (final (index, raw) in sections.indexed) {
        final values = (raw as List<dynamic>).cast<String>();
        if (values.length != 3) {
          throw const EditorialContentException('Cada sección avanzada requiere tipo, título y contenido.');
        }
        final type = LessonBlockType.values.firstWhere(
          (item) => item.name == values[0],
          orElse: () => throw EditorialContentException('Tipo avanzado desconocido: ${values[0]}.'),
        );
        blocks.add(
          LessonBlock(
            type: type,
            title: values[1],
            content: values[2],
            sequence: index + 1,
            questions: type == LessonBlockType.challenge
                ? const <LessonQuestion>[
                    LessonQuestion(
                      question: '¿Completaste esta actividad por escrito?',
                      options: <String>['Todavía no', 'Sí, la completé'],
                      correctAnswer: 1,
                      explanation: 'El aprendizaje activo exige producir una respuesta propia.',
                    ),
                  ]
                : const <LessonQuestion>[],
          ),
        );
      }

      blocks.add(
        LessonBlock(
          type: LessonBlockType.quiz,
          title: 'Autoevaluación',
          content: 'Respondé las ocho preguntas. Cada error incluye una explicación para volver a pensar.',
          sequence: blocks.length + 1,
          questions: quiz.map((raw) {
            final values = raw as List<dynamic>;
            final options = (values[1] as List<dynamic>).cast<String>();
            final correct = values[2] as int;
            return LessonQuestion(
              question: values[0] as String,
              options: options,
              correctAnswer: correct,
              explanation: 'La opción correcta es "${options[correct]}" porque aplica la definición y los controles desarrollados en esta misión.',
            );
          }).toList(),
        ),
      );
    } else {
      throw EditorialContentException('Misión sin bloques ni secciones en $path');
    }

    if (blocks.isEmpty) {
      throw const EditorialContentException('Una misión no puede estar vacía.');
    }

    final displayTitle = id.startsWith('lesson-')
        ? 'MISIÓN ${id.split('-').last} — $title'
        : title;

    return Lesson(
      id: id,
      contentVersion: contentVersion,
      title: displayTitle,
      objective: objective,
      estimatedMinutes: duration,
      concepts: concepts,
      blocks: blocks,
    );
  }

  // --- VALIDACIONES DE INTEGRIDAD ---

  void _validateIntegrity() {
    // 1. Validar enlaces del diccionario
    final termIds = _terms.map((t) => t.id).toSet();
    for (final term in _terms) {
      for (final relatedId in term.related) {
        if (!termIds.contains(relatedId)) {
          throw EditorialContentException(
            'Error editorial: El término "${term.id}" enlazaza a "$relatedId", que no existe.',
          );
        }
      }
    }

    // 2. Validar prerrequisitos existentes
    for (final m in _lessonsMetadata.values) {
      for (final preId in m.prerequisites) {
        if (!_lessonsMetadata.containsKey(preId)) {
          throw EditorialContentException(
            'Error editorial: La misión "${m.id}" requiere como prerrequisito "$preId", que no existe.',
          );
        }
      }
    }

    // 3. Detección de ciclos de dependencias
    _detectCycles();

    // 4. Validar integridad cruzada de módulos, competencias y habilidades
    final skillIds = _skills.map((s) => s.id).toSet();
    final competencyIds = _competencies.map((c) => c.id).toSet();

    for (final comp in _competencies) {
      for (final skillId in comp.skillIds) {
        if (!skillIds.contains(skillId)) {
          throw EditorialContentException(
            'Error de integridad: La competencia "${comp.id}" refiere a la habilidad "$skillId", que no existe.',
          );
        }
      }
    }

    for (final track in _tracks) {
      for (final compId in track.competencyIds) {
        if (!competencyIds.contains(compId)) {
          throw EditorialContentException(
            'Error de integridad: El track "${track.id}" refiere a la competencia "$compId", que no existe.',
          );
        }
      }
    }

    // 5. Validar que misiones referenciadas en rutas de carrera y proyectos existan
    final lessonNumbers = _lessonsMetadata.keys.map((id) => id.split('-').last).toSet();
    for (final path in _careerPaths) {
      for (final mNum in path.missions) {
        if (!lessonNumbers.contains(mNum)) {
          throw EditorialContentException(
            'Error de integridad: La ruta de carrera "${path.id}" refiere a la misión "$mNum", que no existe.',
          );
        }
      }
    }

    for (final proj in _projects) {
      for (final mNum in proj.missions) {
        if (!lessonNumbers.contains(mNum)) {
          throw EditorialContentException(
            'Error de integridad: El proyecto "${proj.id}" refiere a la misión "$mNum", que no existe.',
          );
        }
      }
    }
  }

  void _detectCycles() {
    final visited = <String, int>{}; // 0: no visitado, 1: visitando, 2: completamente procesado
    for (final id in _lessonsMetadata.keys) {
      visited[id] = 0;
    }

    bool dfs(String node) {
      visited[node] = 1;
      final metadata = _lessonsMetadata[node]!;
      for (final neighbor in metadata.prerequisites) {
        if (visited[neighbor] == 1) {
          return true;
        }
        if (visited[neighbor] == 0) {
          if (dfs(neighbor)) return true;
        }
      }
      visited[node] = 2;
      return false;
    }

    for (final id in _lessonsMetadata.keys) {
      if (visited[id] == 0) {
        if (dfs(id)) {
          throw const EditorialContentException(
            'Error editorial: Se detectó un ciclo cerrado de prerrequisitos entre las misiones.',
          );
        }
      }
    }
  }
}

/// Metadatos básicos de una lección leídos de su cabecera en el arranque.
final class LessonMetadata {
  const LessonMetadata({
    required this.id,
    required this.title,
    required this.duration,
    required this.concepts,
    required this.prerequisites,
    required this.sourcePath,
  });
  final String id;
  final String title;
  final int duration;
  final List<String> concepts;
  final List<String> prerequisites;
  final String sourcePath;
}

/// Elemento del manifiesto editorial.
final class EditorialManifestItem {
  const EditorialManifestItem({
    required this.id,
    required this.title,
    required this.sources,
  });
  final String id;
  final String title;
  final List<String> sources;
}
