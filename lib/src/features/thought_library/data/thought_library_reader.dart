import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:oraculo_ia/src/features/thought_library/domain/thought_library.dart';

final class ThoughtLibraryReader {
  const ThoughtLibraryReader();
  Future<ThoughtLibrary> load() async {
    final base = parse(
      await rootBundle.loadString('knowledge/thought_library_v1.json'),
    );
    final extra = parse(
      await rootBundle.loadString('knowledge/thought_library_expansion_v1.json'),
    );
    return ThoughtLibrary(
      topics: <String>{...base.topics, ...extra.topics}.toList(),
      authors: <String>{...base.authors, ...extra.authors}.toList(),
      ideas: <ThoughtIdea>[...base.ideas, ...extra.ideas],
    );
  }
  ThoughtLibrary parse(String source) {
    final root = jsonDecode(source);
    if (root is! Map<String, dynamic> || root['schemaVersion'] != 1) {
      throw const ThoughtLibraryException('Esquema editorial incompatible.');
    }
    final topics = (root['topics'] as List).cast<String>();
    final authors = (root['authors'] as List).cast<String>();
    final ideas =
        (root['ideas'] as List).cast<Map<String, dynamic>>().map((item) {
          String text(String key) {
            final value = item[key];
            if (value is! String || value.isEmpty) {
              throw ThoughtLibraryException('Falta $key.');
            }
            return value;
          }

          final author = text('author'),
              topic = text('topic'),
              kind = text('kind');
          if (!authors.contains(author) || !topics.contains(topic)) {
            throw ThoughtLibraryException('Autor o tema no declarado.');
          }
          if (!const [
            'cita textual',
            'paráfrasis',
            'interpretación editorial',
            'aplicación práctica',
          ].contains(kind)) {
            throw ThoughtLibraryException('Tipo editorial inválido.');
          }
          return ThoughtIdea(
            id: text('id'),
            author: author,
            topic: topic,
            kind: kind,
            title: text('title'),
            body: text('body'),
            application: text('application'),
            concepts: (item['concepts'] as List).cast<String>(),
            source: item['source'] as String?,
            date: item['date'] as String?,
            context: item['context'] as String?,
            verification: item['verification'] as String?,
          );
        }).toList();
    return ThoughtLibrary(topics: topics, authors: authors, ideas: ideas);
  }
}
