import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';

void main() {
  test('without saved data, mentor asks the person to set their job first', () {
    const profile = LearnerProfile();
    final example = mentorWorkExample('verificación', profile);
    expect(profile.hasWork, isFalse);
    expect(example, contains('Mi perfil'));
  });
  test('once a job is saved, examples are personalized to that job, not a fixed one', () {
    const profile = LearnerProfile(name: 'Ana', work: 'bibliotecaria');
    final example = mentorWorkExample('verificación', profile);
    expect(profile.hasWork, isTrue);
    expect(example, contains('bibliotecaria'));
    expect(example, contains('aprobación humana'));
  });
  test('mentor alternatives remain editorial and deterministic', () {
    expect(mentorAlternative('RAG'), contains('RAG'));
    expect(mentorHardExample('agentes'), contains('fuentes contradictorias'));
  });
}
