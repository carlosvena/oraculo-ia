import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

final class KnowledgeContent {
  const KnowledgeContent({
    required this.lessons,
    required this.articles,
    required this.terms,
  });
  final List<Lesson> lessons;
  final List<KnowledgeArticle> articles;
  final List<DictionaryTerm> terms;

  Lesson lesson(String id) => lessons.firstWhere((item) => item.id == id);
  List<KnowledgeArticle> search(String query) {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) return articles;
    return articles
        .where((a) => '${a.title} ${a.body}'.toLowerCase().contains(value))
        .toList();
  }

  DictionaryTerm term(String id) => terms.firstWhere((item) => item.id == id);
}

final class KnowledgeArticle {
  const KnowledgeArticle({
    required this.id,
    required this.title,
    required this.body,
    required this.links,
  });
  final String id;
  final String title;
  final String body;
  final List<String> links;
}

final class DictionaryTerm {
  const DictionaryTerm({
    required this.id,
    required this.term,
    required this.definition,
    required this.explanation,
    required this.analogy,
    required this.example,
    required this.mistake,
    required this.related,
  });
  final String id;
  final String term;
  final String definition;
  final String explanation;
  final String analogy;
  final String example;
  final String mistake;
  final List<String> related;
}

final class EditorialContentException implements Exception {
  const EditorialContentException(this.message);
  final String message;
  @override
  String toString() => 'Error editorial: $message';
}
