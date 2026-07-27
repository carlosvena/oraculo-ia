import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/thought_library/data/thought_library_reader.dart';

void main() {
  test('loads attributed editorial ideas and filters them', () async {
    final source =
        await File('knowledge/thought_library_v1.json').readAsString();
    final library = const ThoughtLibraryReader().parse(source);
    expect(library.authors, hasLength(6));
    expect(library.topics, hasLength(8));
    expect(library.ideas.every((idea) => idea.kind != 'cita textual'), isTrue);
    expect(library.search('proyectos', author: 'Andrew Ng'), isNotEmpty);
    expect(
      library.search('', topic: 'Riesgos de la IA').single.author,
      'Fei-Fei Li',
    );
  });
}
