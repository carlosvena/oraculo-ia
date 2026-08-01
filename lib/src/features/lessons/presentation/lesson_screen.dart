import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/components/primary_mission_action.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart' as domain;
import 'package:oraculo_ia/src/features/lessons/presentation/lesson_block.dart';
import 'package:oraculo_ia/src/features/lessons/presentation/lesson_providers.dart';
import 'package:oraculo_ia/src/features/mentor/presentation/mentor_voice_panel.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

/// Arma el texto completo que el mentor debería leer en voz alta: antes
/// solo leía `block.content` y se saltaba la lista de puntos y el
/// recuadro destacado (donde suelen ir los ejemplos "entre comillas").
String _fullReadableText(domain.LessonBlock block) {
  final parts = <String>[block.content];
  if (block.items.isNotEmpty) {
    parts.add(block.items.join('. '));
  }
  if (block.prompt != null && !block.prompt!.startsWith('Leer más:')) {
    parts.add(block.prompt!);
  }
  return parts.join('. ');
}

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({
    required this.missionId,
    required this.lessonId,
    required this.onComplete,
    super.key,
  });

  final String missionId;
  final String lessonId;
  final Future<void> Function() onComplete;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  var _currentBlock = 0;
  var _isCompleting = false;
  String _laboratoryAnswer = '';
  final List<int?> _quizAnswers = List<int?>.filled(8, null);
  var _restored = false;

  bool _canContinue(domain.LessonBlock block) => switch (block.type) {
    domain.LessonBlockType.challenge =>
      block.questions.isEmpty || _laboratoryAnswer.trim().length >= 15,
    domain.LessonBlockType.quiz => block.questions.indexed.every(
      (entry) => _quizAnswers[entry.$1] == entry.$2.correctAnswer,
    ),
    _ => true,
  };

  List<domain.LessonBlock> _visibleBlocks(
    domain.Lesson lesson,
    LearningMode mode,
    String work,
  ) {
    final base =
        mode == LearningMode.intensive
            ? lesson.blocks
            : lesson.blocks
                .where(
                  (block) =>
                      block.type != domain.LessonBlockType.challenge &&
                      block.type != domain.LessonBlockType.analogy,
                )
                .toList();
    final phrase = work.trim().isEmpty ? 'tu trabajo' : work.trim();
    return base
        .map(
          (block) => block.copyWith(
            title: domain.applyWorkPlaceholder(block.title, phrase),
            content: domain.applyWorkPlaceholder(block.content, phrase),
            prompt: block.prompt == null
                ? null
                : domain.applyWorkPlaceholder(block.prompt!, phrase),
          ),
        )
        .toList();
  }

  Future<void> _continue(domain.Lesson lesson, int blockCount) async {
    if (_currentBlock < blockCount - 1) {
      setState(() => _currentBlock++);
      await ref
          .read(learningStateProvider.notifier)
          .savePosition(widget.lessonId, _currentBlock, _quizAnswers);
      return;
    }
    setState(() => _isCompleting = true);
    try {
      await ref
          .read(learningStateProvider.notifier)
          .complete(widget.lessonId, lesson.estimatedMinutes, lesson.concepts);
      await widget.onComplete();
    } on Object {
      if (!mounted) return;
      setState(() => _isCompleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).missionCompleteError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lessonValue = ref.watch(lessonProvider(widget.lessonId));
    final lesson = lessonValue.value;
    final persisted = ref.watch(learningStateProvider).value;
    final work = persisted?.learnerWork ?? '';
    final visible =
        lesson == null
            ? const <domain.LessonBlock>[]
            : _visibleBlocks(lesson, persisted?.mode ?? LearningMode.intensive, work);
    if (_currentBlock >= visible.length && visible.isNotEmpty) {
      _currentBlock = visible.length - 1;
    }
    final block = visible.isEmpty ? null : visible[_currentBlock];
    if (!_restored &&
        lesson != null &&
        persisted != null &&
        persisted.currentLessonId == widget.lessonId) {
      _restored = true;
      _currentBlock = persisted.currentBlock.clamp(0, visible.length - 1);
      final saved = persisted.answers[widget.lessonId] ?? const <int?>[];
      for (
        var index = 0;
        index < saved.length && index < _quizAnswers.length;
        index++
      ) {
        _quizAnswers[index] = saved[index];
      }
    }

    return OraculoScaffold(
      bottomAction: PrimaryMissionAction(
        label:
            _currentBlock == (visible.isEmpty ? 1 : visible.length) - 1
                ? l10n.completeMission
                : 'CONTINUAR',
        isLoading: _isCompleting,
        onPressed:
            lesson != null && block != null && _canContinue(block)
                ? () => _continue(lesson, visible.length)
                : null,
        disabledHint: switch (block?.type) {
          domain.LessonBlockType.quiz =>
            'Elegí la respuesta correcta en cada pregunta para poder continuar.',
          domain.LessonBlockType.challenge =>
            (block?.questions.isNotEmpty ?? false)
                ? 'Escribí tu respuesta a la actividad para poder continuar.'
                : null,
          _ => null,
        },
      ),
      body: AsyncContent<domain.Lesson>(
        value: lessonValue,
        errorMessage: l10n.lessonLoadError,
        retryLabel: l10n.retry,
        onRetry: () => ref.invalidate(lessonProvider(widget.lessonId)),
        data: (value) {
          final blocks = _visibleBlocks(
            value,
            persisted?.mode ?? LearningMode.intensive,
            work,
          );
          final current = blocks[_currentBlock];
          final progress = (_currentBlock + 1) / blocks.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Bloque ${_currentBlock + 1} de ${blocks.length}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Text('${(progress * 100).round()}%'),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(value: progress, minHeight: 8),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.xs,
                children: <Widget>[
                  _TimeMetric(
                    icon: Icons.schedule_rounded,
                    label: 'Estimado: ${lesson?.estimatedMinutes ?? 15} minutos',
                  ),
                  _TimeMetric(
                    icon: Icons.timer_outlined,
                    label: 'Transcurrido: ${2 + (_currentBlock * 2)} min',
                  ),
                ],
              ),
              if (persisted != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<LearningMode>(
                  segments: const <ButtonSegment<LearningMode>>[
                    ButtonSegment(
                      value: LearningMode.essential,
                      label: Text('Esencial'),
                    ),
                    ButtonSegment(
                      value: LearningMode.intensive,
                      label: Text('Intensivo'),
                    ),
                  ],
                  selected: <LearningMode>{persisted.mode},
                  onSelectionChanged:
                      (values) => ref
                          .read(learningStateProvider.notifier)
                          .setMode(values.single),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (block != null)
                MentorVoicePanel(title: block.title, text: _fullReadableText(block)),
              if (block != null) const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: SingleChildScrollView(
                  key: ValueKey<int>(_currentBlock),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: LessonBlock(
                      key: ValueKey<int>(current.sequence),
                      block: current,
                      child: switch (current.type) {
                        domain.LessonBlockType.challenge => _Laboratory(
                          questions: current.questions,
                          answer: _laboratoryAnswer,
                          onChanged: (text) {
                            setState(() => _laboratoryAnswer = text);
                            ref
                                .read(learningStateProvider.notifier)
                                .savePosition(
                                  widget.lessonId,
                                  _currentBlock,
                                  _quizAnswers,
                                );
                          },
                        ),
                        domain.LessonBlockType.quiz => _Quiz(
                          questions: current.questions,
                          answers: _quizAnswers,
                          onSelected: (question, answer) {
                            setState(() => _quizAnswers[question] = answer);
                            if (answer != current.questions[question].correctAnswer) {
                              ref.read(learningStateProvider.notifier).recordMistake(widget.lessonId);
                            }
                            ref
                                .read(learningStateProvider.notifier)
                                .savePosition(
                                  widget.lessonId,
                                  _currentBlock,
                                  _quizAnswers,
                                );
                          },
                        ),
                        _ => null,
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TimeMetric extends StatelessWidget {
  const _TimeMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18),
        const SizedBox(width: AppSpacing.xs),
        Text(label),
      ],
    );
  }
}

class _Laboratory extends StatefulWidget {
  const _Laboratory({
    required this.questions,
    required this.answer,
    required this.onChanged,
  });

  final List<domain.LessonQuestion> questions;
  final String answer;
  final ValueChanged<String> onChanged;

  @override
  State<_Laboratory> createState() => _LaboratoryState();
}

class _LaboratoryState extends State<_Laboratory> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.answer);
  }

  @override
  void didUpdateWidget(covariant _Laboratory oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió de bloque (otra actividad), el texto viene de otra
    // respuesta guardada — sincronizamos el controlador con eso.
    if (widget.answer != _controller.text && widget.answer != oldWidget.answer) {
      _controller.value = TextEditingValue(
        text: widget.answer,
        selection: TextSelection.collapsed(offset: widget.answer.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      // Este bloque de laboratorio es solo texto/consigna, sin
      // verificación cargada — no hay nada que renderizar acá.
      return const SizedBox.shrink();
    }
    final enough = widget.answer.trim().length >= 15;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Escribí tu respuesta acá (no alcanza con decir que sí la '
              'hiciste — contá qué decidiste):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 3,
              onChanged: widget.onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tu respuesta a la actividad...',
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              enough
                  ? 'Listo, ya podés continuar.'
                  : 'Escribí un poco más para poder continuar '
                      '(${widget.answer.trim().length}/15).',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color:
                    enough
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Quiz extends StatelessWidget {
  const _Quiz({
    required this.questions,
    required this.answers,
    required this.onSelected,
  });

  final List<domain.LessonQuestion> questions;
  final List<int?> answers;
  final void Function(int question, int answer) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var index = 0; index < questions.length; index++)
          _QuestionCard(
            number: index + 1,
            question: questions[index].question,
            options: questions[index].options,
            selectedAnswer: answers[index],
            correctAnswer: questions[index].correctAnswer,
            explanation: questions[index].explanation,
            onSelected: (answer) => onSelected(index, answer),
          ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.explanation,
    required this.onSelected,
    this.number,
  });

  final int? number;
  final String question;
  final List<String> options;
  final int? selectedAnswer;
  final int correctAnswer;
  final String explanation;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedAnswer == correctAnswer;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            number == null ? question : '$number. $question',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          for (var index = 0; index < options.length; index++)
            _AnswerOption(
              letter: String.fromCharCode(65 + index),
              text: options[index],
              isSelected: selectedAnswer == index,
              isCorrectOption: index == correctAnswer,
              hasAnswered: selectedAnswer != null,
              onTap: () => onSelected(index),
            ),
          if (selectedAnswer != null)
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: (isCorrect ? colors.primary : colors.error).withValues(
                  alpha: 0.16,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isCorrect ? colors.primary : colors.error).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel_outlined,
                    color: isCorrect ? colors.primary : colors.error,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: isCorrect ? colors.primary : colors.error,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: isCorrect
                                ? 'Correcto. '
                                : 'Todavía no, probá otra opción. ',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(text: explanation),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.isCorrectOption,
    required this.hasAnswered,
    required this.onTap,
  });

  final String letter;
  final String text;
  final bool isSelected;
  final bool isCorrectOption;
  final bool hasAnswered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Después de responder: la opción correcta se ve verde siempre,
    // la elegida (si estaba mal) se ve roja, y el resto queda neutra.
    Color background = colors.surfaceContainerHigh;
    Color border = colors.outlineVariant;
    Color foreground = colors.onSurface;
    IconData? trailingIcon;

    if (hasAnswered) {
      if (isCorrectOption) {
        background = colors.primary.withValues(alpha: 0.18);
        border = colors.primary;
        foreground = colors.primary;
        trailingIcon = Icons.check_circle;
      } else if (isSelected) {
        background = colors.error.withValues(alpha: 0.16);
        border = colors.error;
        foreground = colors.error;
        trailingIcon = Icons.cancel;
      }
    } else if (isSelected) {
      background = colors.primaryContainer;
      border = colors.primary;
      foreground = colors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Semantics(
        button: true,
        label: 'Opción $letter: $text',
        selected: isSelected,
        hint:
            hasAnswered
                ? (isCorrectOption
                    ? 'Correcta'
                    : (isSelected ? 'Incorrecta, elegiste esta' : null))
                : null,
        child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border, width: 2),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: border,
                  child: Text(
                    letter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: foreground,
                      fontWeight: (hasAnswered && isCorrectOption) || isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(trailingIcon, color: foreground, size: 26),
                ],
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
