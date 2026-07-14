import 'dart:convert';
import 'dart:io';
import 'package:oraculo_ia/src/features/career/domain/career_path.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/projects/domain/learning_project.dart';
import 'package:oraculo_ia/src/features/prompt_lab/domain/prompt_exercise.dart';
import 'package:oraculo_ia/src/features/thought_library/domain/thought_library.dart';
import 'package:oraculo_ia/src/modules/academy/competency.dart';
import 'package:oraculo_ia/src/modules/academy/skill.dart';
import 'package:oraculo_ia/src/modules/academy/track.dart';

/// Utilidad offline para persistir de forma estructurada los JSON en knowledge/.
final class CreatorStudioExporter {
  const CreatorStudioExporter();

  /// Encuentra de manera robusta la carpeta 'knowledge' desde el directorio de ejecución actual
  Directory findKnowledgeDirectory() {
    var dir = Directory.current;
    for (var i = 0; i < 5; i++) {
      final kDir = Directory('${dir.path}/knowledge');
      if (kDir.existsSync()) {
        return kDir;
      }
      dir = dir.parent;
    }
    return Directory('knowledge'); // Fallback por defecto
  }

  void saveCareerPaths(List<CareerPath> paths) {
    final kDir = findKnowledgeDirectory();
    final file = File('${kDir.path}/career_paths_v1.json');
    final data = {
      'schemaVersion': 1,
      'paths': paths.map((p) => {
        'id': p.id,
        'priority': p.priority,
        'title': p.title,
        'level': p.level,
        'skills': p.skills,
        'missions': p.missions,
        'projects': p.projects,
        'hours': p.hours,
        'final': p.finalEvaluation,
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  void saveProjects(List<LearningProject> projects) {
    final kDir = findKnowledgeDirectory();
    final file = File('${kDir.path}/projects_v1.json');
    final data = {
      'schemaVersion': 1,
      'projects': projects.map((p) => {
        'id': p.id,
        'title': p.title,
        'objective': p.objective,
        'knowledge': p.knowledge,
        'missions': p.missions,
        'steps': p.steps,
        'deliverables': p.deliverables,
        'success': p.success,
        'risks': p.risks,
        'evaluation': p.evaluation,
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  void savePromptExercises(List<PromptExercise> exercises) {
    final kDir = findKnowledgeDirectory();
    final file = File('${kDir.path}/prompt_exercises_v1.json');
    final data = {
      'schemaVersion': 1,
      'exercises': exercises.map((e) => {
        'id': e.id,
        'category': e.category,
        'level': e.level,
        'title': e.title,
        'original': e.original,
        'improved': e.improved,
        'why': e.why,
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  void saveThoughtLibrary(ThoughtLibrary library) {
    final kDir = findKnowledgeDirectory();
    // Guardar todo consolidado en thought_library_v1.json
    final file = File('${kDir.path}/thought_library_v1.json');
    final data = {
      'schemaVersion': 1,
      'topics': library.topics,
      'authors': library.authors,
      'ideas': library.ideas.map((i) => {
        'id': i.id,
        'author': i.author,
        'topic': i.topic,
        'kind': i.kind,
        'title': i.title,
        'body': i.body,
        'application': i.application,
        'concepts': i.concepts,
        'source': i.source,
        'date': i.date,
        'context': i.context,
        'verification': i.verification,
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));

    // Dejar la expansión vacía/limpia
    final expFile = File('${kDir.path}/thought_library_expansion_v1.json');
    final expData = {
      'schemaVersion': 1,
      'topics': const <String>[],
      'authors': const <String>[],
      'ideas': const <dynamic>[],
    };
    expFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(expData));
  }

  void saveDictionary(List<DictionaryTerm> terms) {
    final kDir = findKnowledgeDirectory();
    final file = File('${kDir.path}/dictionary_v1.json');
    final data = {
      'schemaVersion': 1,
      'dictionary': terms.map((t) => {
        'id': t.id,
        'term': t.term,
        'definition': t.definition,
        'explanation': t.explanation,
        'analogy': t.analogy,
        'example': t.example,
        'mistake': t.mistake,
        'related': t.related,
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  void saveManual(List<KnowledgeArticle> articles) {
    final kDir = findKnowledgeDirectory();
    final file = File('${kDir.path}/manual_v1.json');
    final data = {
      'schemaVersion': 1,
      'articles': articles.map((a) => {
        'id': a.id,
        'title': a.title,
        'body': a.body,
        'links': a.links,
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  void saveModules(List<Track> tracks, List<Competency> competencies, List<Skill> skills) {
    final kDir = findKnowledgeDirectory();
    final file = File('${kDir.path}/modules_v1.json');
    final data = {
      'schemaVersion': 1,
      'tracks': tracks.map((t) => {
        'id': t.id,
        'name': t.name,
        'description': t.description,
        'competencyIds': t.competencyIds.toList(),
        'missionSequenceIds': t.missionSequenceIds,
      }).toList(),
      'competencies': competencies.map((c) => {
        'id': c.id,
        'name': c.name,
        'description': c.description,
        'skillIds': c.skillIds.toList(),
        'targetLevel': c.targetLevel.name[0].toUpperCase() + c.targetLevel.name.substring(1),
      }).toList(),
      'skills': skills.map((s) => {
        'id': s.id,
        'name': s.name,
        'description': s.description,
        'tags': s.tags.toList(),
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  void saveLesson(Lesson lesson, String sourcePath) {
    final kDir = findKnowledgeDirectory();
    
    // Si la ruta del archivo es relativa, resolverla
    final relativePath = sourcePath.startsWith('knowledge/')
        ? sourcePath.substring(10)
        : sourcePath;

    final file = File('${kDir.path}/$relativePath');
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }

    final missionData = {
      'id': lesson.id,
      'version': lesson.contentVersion,
      'title': lesson.title.startsWith('MISIÓN') 
          ? lesson.title.split(' — ').skip(1).join(' — ')
          : lesson.title,
      'objective': lesson.objective,
      'duration': lesson.estimatedMinutes,
      'concepts': lesson.concepts,
      'prerequisiteIds': const <String>[], // Se rellenará o mantendrá vacío
      'blocks': lesson.blocks.map((b) => {
        'type': b.type.name,
        'title': b.title,
        'content': b.content,
        'items': b.items,
        'prompt': b.prompt,
        'questions': b.questions.map((q) => {
          'question': q.question,
          'options': q.options,
          'correct': q.correctAnswer,
          'explanation': q.explanation,
        }).toList(),
      }).toList(),
    };

    final data = {
      'schemaVersion': 1,
      'mission': missionData,
    };

    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  void saveManifest(List<EditorialManifestItem> items) {
    final kDir = findKnowledgeDirectory();
    final file = File('${kDir.path}/editorial_manifest_v1.json');
    final data = {
      'schemaVersion': 1,
      'items': items.map((i) => {
        'id': i.id,
        'title': i.title,
        'sources': i.sources,
      }).toList(),
    };
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }
}
