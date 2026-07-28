import 'package:flutter_test/flutter_test.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';

void main() {
  group('applyWorkPlaceholder', () {
    test('replaces {{trabajo}} with the real saved work', () {
      final result = applyWorkPlaceholder(
        'Aplicá esto a {{trabajo}} hoy mismo.',
        'bibliotecaria',
      );
      expect(result, 'Aplicá esto a bibliotecaria hoy mismo.');
    });

    test('falls back to a generic phrase when work is empty', () {
      final result = applyWorkPlaceholder('Pensá en {{trabajo}}.', '');
      expect(result, 'Pensá en tu trabajo.');
    });

    test('falls back to generic phrase when work is only whitespace', () {
      final result = applyWorkPlaceholder('Pensá en {{trabajo}}.', '   ');
      expect(result, 'Pensá en tu trabajo.');
    });

    test('is not tied to any single hardcoded profession', () {
      for (final job in <String>['contador', 'docente', 'comerciante', 'bibliotecario']) {
        final result = applyWorkPlaceholder('Esto aplica a {{trabajo}}.', job);
        expect(result, contains(job));
      }
    });

    test('leaves text without the placeholder untouched', () {
      const text = 'Este texto no tiene el token.';
      expect(applyWorkPlaceholder(text, 'lo que sea'), text);
    });
  });

  test('LessonBlock.copyWith replaces only the given fields', () {
    const original = LessonBlock(
      type: LessonBlockType.text,
      title: 'Título {{trabajo}}',
      content: 'Contenido {{trabajo}}',
      sequence: 1,
      prompt: 'Prompt {{trabajo}}',
    );
    final updated = original.copyWith(
      title: 'Título bibliotecaria',
      content: 'Contenido bibliotecaria',
      prompt: 'Prompt bibliotecaria',
    );
    expect(updated.title, 'Título bibliotecaria');
    expect(updated.content, 'Contenido bibliotecaria');
    expect(updated.prompt, 'Prompt bibliotecaria');
    // El resto de los campos no debería cambiar.
    expect(updated.type, original.type);
    expect(updated.sequence, original.sequence);
  });
}
