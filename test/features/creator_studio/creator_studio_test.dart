import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/career/domain/career_path.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/creator_studio/data/creator_studio_exporter.dart';
import 'package:oraculo_ia/src/features/projects/domain/learning_project.dart';
import 'package:oraculo_ia/src/features/thought_library/domain/thought_library.dart';

void main() {
  group('Creator Studio CMS Tests', () {
    const exporter = CreatorStudioExporter();

    test('Exporter finds knowledge directory offline', () {
      final kDir = exporter.findKnowledgeDirectory();
      expect(kDir.existsSync(), isTrue);
      expect(Directory('${kDir.path}/missions').existsSync(), isTrue);
    });

    test('Runs validation rules for orphan terms and broken links', () {
      // Simular validaciones lógicas
      final terms = [
        const DictionaryTerm(
          id: 'term-criterio',
          term: 'Criterio',
          definition: 'Definición',
          explanation: 'Explicación',
          analogy: 'Analogía',
          example: 'Ejemplo',
          mistake: 'Error',
          related: ['term-inexistente'], // Enlace roto
        ),
      ];

      final brokenLinks = <String>[];
      final termIds = terms.map((t) => t.id).toSet();
      for (final term in terms) {
        for (final rel in term.related) {
          if (!termIds.contains(rel)) {
            brokenLinks.add('Broken link in ${term.term} to $rel');
          }
        }
      }

      expect(brokenLinks, hasLength(1));
      expect(brokenLinks.first, contains('Broken link in Criterio to term-inexistente'));
    });

    test('Runs validation for thought library: quote must have a source', () {
      final ideas = [
        ThoughtIdea(
          id: 'idea-1',
          author: 'Carlos',
          topic: 'Automatización',
          kind: 'cita textual',
          title: 'Una cita',
          body: 'Contenido de la cita',
          application: 'Aplicación',
          concepts: const [],
          source: '', // Fuente vacía
        ),
      ];

      final invalidQuotes = ideas.where((i) => i.kind == 'cita textual' && (i.source == null || i.source!.trim().isEmpty)).toList();
      expect(invalidQuotes, hasLength(1));
    });

    test('Validates projects references to missions', () {
      final projects = [
        const LearningProject(
          'proj-1',
          'Proyecto de prueba',
          'Objetivo',
          [],
          ['999'], // Misión inexistente
          [],
          [],
          [],
          [],
          'Evaluación',
        ),
      ];

      final lessonNumbers = {'001', '002', '003'}; // Misiones reales cargadas
      final invalidMissions = <String>[];

      for (final proj in projects) {
        for (final mNum in proj.missions) {
          if (!lessonNumbers.contains(mNum)) {
            invalidMissions.add('Proyecto ${proj.title} refiere a misión inexistente $mNum');
          }
        }
      }

      expect(invalidMissions, hasLength(1));
      expect(invalidMissions.first, contains('refiere a misión inexistente 999'));
    });
  });
}
