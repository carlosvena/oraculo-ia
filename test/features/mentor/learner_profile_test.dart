import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';

void main() {
  test('local profile personalizes banking examples without a service', () {
    const profile = LearnerProfile();
    final example = mentorWorkExample('verificación', profile);
    expect(profile.intensive, isTrue);
    expect(example, contains('supervisor bancario'));
    expect(example, contains('aprobación humana'));
  });
  test('mentor alternatives remain editorial and deterministic', () {
    expect(mentorAlternative('RAG'), contains('RAG'));
    expect(mentorHardExample('agentes'), contains('fuentes contradictorias'));
  });
}
