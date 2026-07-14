class ProfessionalCase {
  final String id;
  final String category;
  final String categoryName;
  final String title;
  final String description;
  final List<String> steps;
  final List<String> tools;
  final String promptExample;
  final String expectedResult;

  const ProfessionalCase({
    required this.id,
    required this.category,
    required this.categoryName,
    required this.title,
    required this.description,
    required this.steps,
    required this.tools,
    required this.promptExample,
    required this.expectedResult,
  });

  factory ProfessionalCase.fromJson(Map<String, dynamic> json) {
    return ProfessionalCase(
      id: json['id'] as String,
      category: json['category'] as String,
      categoryName: json['categoryName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      steps: List<String>.from(json['steps'] as List),
      tools: List<String>.from(json['tools'] as List),
      promptExample: json['promptExample'] as String,
      expectedResult: json['expectedResult'] as String,
    );
  }
}

class ProfessionalPrompt {
  final String id;
  final String category;
  final String title;
  final String objective;
  final String whenToUse;
  final String howToAdapt;
  final String commonMistakes;
  final String example;
  final String expectedResult;

  const ProfessionalPrompt({
    required this.id,
    required this.category,
    required this.title,
    required this.objective,
    required this.whenToUse,
    required this.howToAdapt,
    required this.commonMistakes,
    required this.example,
    required this.expectedResult,
  });

  factory ProfessionalPrompt.fromJson(Map<String, dynamic> json) {
    return ProfessionalPrompt(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      objective: json['objective'] as String,
      whenToUse: json['whenToUse'] as String,
      howToAdapt: json['howToAdapt'] as String,
      commonMistakes: json['commonMistakes'] as String,
      example: json['example'] as String,
      expectedResult: json['expectedResult'] as String,
    );
  }
}

class ProfessionalTemplate {
  final String id;
  final String title;
  final String description;
  final String template;

  const ProfessionalTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.template,
  });

  factory ProfessionalTemplate.fromJson(Map<String, dynamic> json) {
    return ProfessionalTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      template: json['template'] as String,
    );
  }
}

class ProfessionalSimulator {
  final String id;
  final String title;
  final String scenario;
  final String correctModel;
  final List<String> modelOptions;
  final Map<String, String> modelExplanations;
  final List<String> verificationItems;

  const ProfessionalSimulator({
    required this.id,
    required this.title,
    required this.scenario,
    required this.correctModel,
    required this.modelOptions,
    required this.modelExplanations,
    required this.verificationItems,
  });

  factory ProfessionalSimulator.fromJson(Map<String, dynamic> json) {
    return ProfessionalSimulator(
      id: json['id'] as String,
      title: json['title'] as String,
      scenario: json['scenario'] as String,
      correctModel: json['correctModel'] as String,
      modelOptions: List<String>.from(json['modelOptions'] as List),
      modelExplanations: Map<String, String>.from(json['modelExplanations'] as Map),
      verificationItems: List<String>.from(json['verificationItems'] as List),
    );
  }
}

class ProfessionalChallenge {
  final String id;
  final String difficulty;
  final String category;
  final String title;
  final String description;
  final List<String> constraints;
  final List<String> verificationSteps;

  const ProfessionalChallenge({
    required this.id,
    required this.difficulty,
    required this.category,
    required this.title,
    required this.description,
    required this.constraints,
    required this.verificationSteps,
  });

  factory ProfessionalChallenge.fromJson(Map<String, dynamic> json) {
    return ProfessionalChallenge(
      id: json['id'] as String,
      difficulty: json['difficulty'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      constraints: List<String>.from(json['constraints'] as List),
      verificationSteps: List<String>.from(json['verificationSteps'] as List),
    );
  }
}

class ResourceGuide {
  final String id;
  final String title;
  final String content;

  const ResourceGuide({
    required this.id,
    required this.title,
    required this.content,
  });

  factory ResourceGuide.fromJson(Map<String, dynamic> json) {
    return ResourceGuide(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}

class ResourceChecklist {
  final String id;
  final String title;
  final List<String> items;

  const ResourceChecklist({
    required this.id,
    required this.title,
    required this.items,
  });

  factory ResourceChecklist.fromJson(Map<String, dynamic> json) {
    return ResourceChecklist(
      id: json['id'] as String,
      title: json['title'] as String,
      items: List<String>.from(json['items'] as List),
    );
  }
}

class ResourceProcedure {
  final String id;
  final String title;
  final List<String> steps;

  const ResourceProcedure({
    required this.id,
    required this.title,
    required this.steps,
  });

  factory ResourceProcedure.fromJson(Map<String, dynamic> json) {
    return ResourceProcedure(
      id: json['id'] as String,
      title: json['title'] as String,
      steps: List<String>.from(json['steps'] as List),
    );
  }
}
