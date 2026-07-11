final class ThoughtLibrary {
  const ThoughtLibrary({
    required this.topics,
    required this.authors,
    required this.ideas,
  });
  final List<String> topics;
  final List<String> authors;
  final List<ThoughtIdea> ideas;
  List<ThoughtIdea> search(String query, {String? topic, String? author}) {
    final q = query.trim().toLowerCase();
    return ideas
        .where(
          (idea) =>
              (q.isEmpty ||
                  '${idea.title} ${idea.body} ${idea.application}'
                      .toLowerCase()
                      .contains(q)) &&
              (topic == null || idea.topic == topic) &&
              (author == null || idea.author == author),
        )
        .toList();
  }
}

final class ThoughtIdea {
  const ThoughtIdea({
    required this.id,
    required this.author,
    required this.topic,
    required this.kind,
    required this.title,
    required this.body,
    required this.application,
    required this.concepts,
  });
  final String id, author, topic, kind, title, body, application;
  final List<String> concepts;
}

final class ThoughtLibraryException implements Exception {
  const ThoughtLibraryException(this.message);
  final String message;
}
