import 'dart:convert';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/model_comparator/domain/model_profile.dart';

class ModelCatalogReader {
  const ModelCatalogReader();
  Future<List<ModelProfile>> load() async {
    final engine = KnowledgeEngine.instance;
    await engine.initialize();
    return engine.modelCatalog;
  }
  List<ModelProfile> parse(String source) {
    final root = jsonDecode(source) as Map<String, dynamic>;
    if (root['schemaVersion'] != 1) throw const FormatException('Catálogo de modelos incompatible.');
    return (root['models'] as List).cast<Map<String, dynamic>>().map((item) {
      String text(String key) => item[key] as String;
      List<String> list(String key) => (item[key] as List).cast<String>();
      return ModelProfile(id:text('id'), name:text('name'), what:text('what'), strengths:list('strengths'), limits:list('limits'), uses:list('uses'), avoid:text('avoid'), privacy:text('privacy'), availability:text('availability'), related:list('related'), source:text('source'), verified:item['verified'] as bool);
    }).toList();
  }
}

List<ModelProfile> recommendModels(List<ModelProfile> models, String task) =>
    models.where((model) => model.uses.contains(task)).toList()
      ..sort((a, b) => b.verified.toString().compareTo(a.verified.toString()));
