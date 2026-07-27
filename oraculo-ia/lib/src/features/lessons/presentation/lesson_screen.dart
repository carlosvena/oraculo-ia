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
  int? _laboratoryAnswer;
  final List<int?> _quizAnswers = List<int?>.filled(8, null);
  var _restored = false;

  bool get _laboratoryComplete => _laboratoryAnswer == 1;

  bool _canContinue(domain.LessonBlock block) => switch (block.type) {
    domain.LessonBlockType.challenge => _laboratoryComplete,
    domain.LessonBlockType.quiz => block.questions.indexed.every(
      (entry) => _quizAnswers[entry.$1] == entry.$2.correctAnswer,
    ),
    _ => true,
  };

  List<domain.LessonBlock> _visibleBlocks(
    domain.Lesson lesson,
    LearningMode mode,
  ) {
    if (mode == LearningMode.intensive) return lesson.blocks;
    return lesson.blocks
        .where(
          (block) =>
              block.type != domain.LessonBlockType.challenge &&
              block.type != domain.LessonBlockType.analogy,
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
    final visible =
        lesson == null
            ? const <domain.LessonBlock>[]
            : _visibleBlocks(lesson, persisted?.mode ?? LearningMode.intensive);
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
                MentorVoicePanel(title: block.title, text: block.content),
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
                          selectedAnswer: _laboratoryAnswer,
                          onSelected: (answer) {
                            setState(() => _laboratoryAnswer = answer);
                            if (answer != current.questions.single.correctAnswer) {
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

class _Laboratory extends StatelessWidget {
  const _Laboratory({
    required this.questions,
    required this.selectedAnswer,
    required this.onSelected,
  });

  final List<domain.LessonQuestion> questions;
  final int? selectedAnswer;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final data = questions.single;
    return _QuestionCard(
      question: data.question,
      options: data.options,
      selectedAnswer: selectedAnswer,
      correctAnswer: data.correctAnswer,
      explanation: data.explanation,
      onSelected: onSelected,
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var index = 0; index < options.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: ChoiceChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(options[index]),
                ),
                selected: selectedAnswer == index,
                onSelected: (_) => onSelected(index),
              ),
            ),
          if (selectedAnswer != null)
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: (isCorrect ? colors.primary : colors.error).withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${isCorrect ? 'Correcto.' : 'Todavía no.'} $explanation',
                style: TextStyle(
                  color: isCorrect ? colors.primary : colors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
