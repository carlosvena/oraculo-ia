import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_reader.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';

void main() {
  late KnowledgeContent content;
  setUpAll(() async {
    final source =
        await File('knowledge/oraculo_content_v1.json').readAsString();
    content = const KnowledgeReader().parse(source);
  });

  test('loads two versioned missions and validates Mission 002', () {
    expect(content.lessons, hasLength(2));
    final mission = content.lesson('lesson-prompts-002');
    expect(mission.blocks, hasLength(12));
    expect(mission.blocks.expand((block) => block.questions), hasLength(9));
  });

  test('rejects editorial content with incompatible schema', () {
    expect(
      () => const KnowledgeReader().parse('{"schemaVersion":2}'),
      throwsA(isA<EditorialContentException>()),
    );
  });

  test('search finds manual articles locally', () {
    expect(
      content.search('evaluar').map((article) => article.id),
      contains('evaluacion'),
    );
    expect(content.search('inexistente'), isEmpty);
  });

  test('dictionary links resolve to existing terms', () {
    for (final term in content.terms) {
      for (final related in term.related) {
        expect(content.term(related).id, related);
      }
    }
  });
}
