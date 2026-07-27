import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_reader.dart';
import 'package:oraculo_ia/src/features/knowledge_map/domain/knowledge_map.dart';

void main() {
  test('builds a connected lightweight map from mission concepts', () async {
    final content = const KnowledgeReader().parse(
      await File('knowledge/oraculo_content_v1.json').readAsString(),
    );
    final nodes = KnowledgeMapBuilder.build(content.lessons);
    expect(nodes.length, content.lessons.expand((m) => m.concepts).length);
    expect(nodes.first.precedes, isEmpty);
    expect(nodes.first.unlocks, isNotEmpty);
    expect(nodes.last.unlocks, isEmpty);
    expect(nodes.map((n) => n.id).toSet(), hasLength(nodes.length));
  });
}
