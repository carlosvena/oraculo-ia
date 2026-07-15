class WorkspaceNote {
  WorkspaceNote({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.updatedAt,
  });

  factory WorkspaceNote.fromJson(Map<String, dynamic> json) => WorkspaceNote(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        tags: List<String>.from(json['tags'] as List),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final DateTime updatedAt;

  WorkspaceNote copyWith({
    String? title,
    String? body,
    List<String>? tags,
    DateTime? updatedAt,
  }) {
    return WorkspaceNote(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'tags': tags,
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class WorkspacePrompt {
  WorkspacePrompt({
    required this.id,
    required this.title,
    required this.promptText,
    required this.tags,
    required this.version,
    this.isFavorite = false,
    required this.relatedConcepts,
    required this.updatedAt,
  });

  factory WorkspacePrompt.fromJson(Map<String, dynamic> json) => WorkspacePrompt(
        id: json['id'] as String,
        title: json['title'] as String,
        promptText: json['promptText'] as String,
        tags: List<String>.from(json['tags'] as List),
        version: json['version'] as int,
        isFavorite: json['isFavorite'] as bool? ?? false,
        relatedConcepts: List<String>.from(json['relatedConcepts'] as List),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  final String id;
  final String title;
  final String promptText;
  final List<String> tags;
  final int version;
  final bool isFavorite;
  final List<String> relatedConcepts;
  final DateTime updatedAt;

  WorkspacePrompt copyWith({
    String? title,
    String? promptText,
    List<String>? tags,
    int? version,
    bool? isFavorite,
    List<String>? relatedConcepts,
    DateTime? updatedAt,
  }) {
    return WorkspacePrompt(
      id: id,
      title: title ?? this.title,
      promptText: promptText ?? this.promptText,
      tags: tags ?? this.tags,
      version: version ?? this.version,
      isFavorite: isFavorite ?? this.isFavorite,
      relatedConcepts: relatedConcepts ?? this.relatedConcepts,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'promptText': promptText,
        'tags': tags,
        'version': version,
        'isFavorite': isFavorite,
        'relatedConcepts': relatedConcepts,
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class WorkspaceExperiment {
  WorkspaceExperiment({
    required this.id,
    required this.objective,
    required this.hypothesis,
    required this.promptText,
    required this.result,
    required this.learning,
    required this.nextSteps,
    required this.createdAt,
  });

  factory WorkspaceExperiment.fromJson(Map<String, dynamic> json) => WorkspaceExperiment(
        id: json['id'] as String,
        objective: json['objective'] as String,
        hypothesis: json['hypothesis'] as String,
        promptText: json['promptText'] as String,
        result: json['result'] as String,
        learning: json['learning'] as String,
        nextSteps: json['nextSteps'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final String id;
  final String objective;
  final String hypothesis;
  final String promptText;
  final String result;
  final String learning;
  final String nextSteps;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'objective': objective,
        'hypothesis': hypothesis,
        'promptText': promptText,
        'result': result,
        'learning': learning,
        'nextSteps': nextSteps,
        'createdAt': createdAt.toIso8601String(),
      };
}

class WorkspaceDocument {
  WorkspaceDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });

  factory WorkspaceDocument.fromJson(Map<String, dynamic> json) => WorkspaceDocument(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        category: json['category'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
      };
}
