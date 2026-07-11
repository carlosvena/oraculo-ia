import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/model_comparator/data/model_catalog_reader.dart';

void main() {
  final models = const ModelCatalogReader().parse(File('knowledge/model_catalog_v1.json').readAsStringSync());
  test('catalog contains ten sourced model profiles', () {
    expect(models, hasLength(10));
    for (final model in models) {
      expect(model.source, startsWith('https://'));
      expect(model.strengths, isNotEmpty);
      expect(model.limits, isNotEmpty);
      expect(model.uses, isNotEmpty);
    }
  });
  test('task comparison returns relevant candidates', () {
    final coding = recommendModels(models, 'programación');
    expect(coding.length, greaterThan(3));
    expect(coding.every((model) => model.uses.contains('programación')), isTrue);
  });
}
