import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/missions/domain/mission.dart';

void main() {
  test('mission is the central learning unit', () {
    final mission = Mission(
      id: 'mission-001',
      contentVersion: 1,
      lessonId: 'lesson-001',
      title: 'Entender qué es un modelo de IA',
      estimatedMinutes: 10,
      sequence: 1,
      prerequisiteIds: const <String>[],
    );

    expect(mission.lessonId, 'lesson-001');
    expect(mission.sequence, 1);
  });
}
