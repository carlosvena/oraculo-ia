import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/components/primary_mission_action.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/lessons/presentation/lesson_providers.dart';

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
  var _isCompleting = false;
  int? _exerciseAnswer;
  final List<int?> _quizAnswers = List<int?>.filled(3, null);

  static const _correctQuizAnswers = <int>[0, 0, 2];

  bool get _exerciseIsCorrect => _exerciseAnswer == 1;

  bool get _quizIsCorrect {
    for (var index = 0; index < _correctQuizAnswers.length; index++) {
      if (_quizAnswers[index] != _correctQuizAnswers[index]) return false;
    }
    return true;
  }

  int get _correctQuizCount {
    var count = 0;
    for (var index = 0; index < _correctQuizAnswers.length; index++) {
      if (_quizAnswers[index] == _correctQuizAnswers[index]) count++;
    }
    return count;
  }

  double get _missionProgress {
    final completedSteps = 1 + (_exerciseIsCorrect ? 1 : 0) + _correctQuizCount;
    return completedSteps / 5;
  }

  Future<void> _complete() async {
    setState(() => _isCompleting = true);
    try {
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
    final lesson = ref.watch(lessonProvider(widget.lessonId));

    return OraculoScaffold(
      bottomAction: PrimaryMissionAction(
        label: l10n.completeMission,
        isLoading: _isCompleting,
        onPressed:
            lesson.hasValue && _exerciseIsCorrect && _quizIsCorrect
                ? _complete
                : null,
      ),
      body: AsyncContent<Lesson>(
        value: lesson,
        errorMessage: l10n.lessonLoadError,
        retryLabel: l10n.retry,
        onRetry: () => ref.invalidate(lessonProvider(widget.lessonId)),
        data:
            (value) => ListView(
              children: <Widget>[
                Text(
                  value.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.missionProgressLabel),
                const SizedBox(height: AppSpacing.xs),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween<double>(begin: 0, end: _missionProgress),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(value: value);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.science_outlined),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(l10n.temporaryContentLabel)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _LessonSection(
                  title: l10n.objectiveTitle,
                  body: value.objective,
                ),
                for (final block in value.blocks)
                  if (block.type == LessonBlockType.laboratory)
                    _InteractiveExercise(
                      selectedAnswer: _exerciseAnswer,
                      onSelected: (answer) {
                        setState(() => _exerciseAnswer = answer);
                      },
                    )
                  else if (block.type == LessonBlockType.miniAssessment)
                    _MiniQuiz(
                      answers: _quizAnswers,
                      onSelected: (question, answer) {
                        setState(() => _quizAnswers[question] = answer);
                      },
                    )
                  else
                    _LessonSection(
                      title: _blockTitle(l10n, block.type),
                      body: block.content,
                      items: block.items,
                      prompt: block.prompt,
                    ),
              ],
            ),
      ),
    );
  }

  String _blockTitle(AppLocalizations l10n, LessonBlockType type) {
    return switch (type) {
      LessonBlockType.context => l10n.contextTitle,
      LessonBlockType.concept => l10n.conceptTitle,
      LessonBlockType.examples => l10n.examplesTitle,
      LessonBlockType.laboratory => l10n.laboratoryTitle,
      LessonBlockType.challenge => l10n.challengeTitle,
      LessonBlockType.debate => l10n.debateTitle,
      LessonBlockType.tools => l10n.toolsTitle,
      LessonBlockType.commonMistake => l10n.commonMistakeTitle,
      LessonBlockType.miniAssessment => l10n.miniAssessmentTitle,
      LessonBlockType.executiveSummary => l10n.executiveSummaryTitle,
      LessonBlockType.nextStep => l10n.nextStepTitle,
    };
  }
}

class _InteractiveExercise extends StatelessWidget {
  const _InteractiveExercise({
    required this.selectedAnswer,
    required this.onSelected,
  });

  final int? selectedAnswer;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = <String>[
      l10n.exerciseOptionOne,
      l10n.exerciseOptionTwo,
      l10n.exerciseOptionThree,
    ];

    return _QuestionCard(
      title: l10n.laboratoryTitle,
      question: l10n.exerciseQuestion,
      options: options,
      selectedAnswer: selectedAnswer,
      correctAnswer: 1,
      correctMessage: l10n.exerciseCorrect,
      incorrectMessage: l10n.exerciseTryAgain,
      onSelected: onSelected,
    );
  }
}

class _MiniQuiz extends StatelessWidget {
  const _MiniQuiz({required this.answers, required this.onSelected});

  final List<int?> answers;
  final void Function(int question, int answer) onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final questions = <_QuestionData>[
      _QuestionData(
        question: l10n.quizQuestionOne,
        options: <String>[
          l10n.quizOneOptionOne,
          l10n.quizOneOptionTwo,
          l10n.quizOneOptionThree,
        ],
        correctAnswer: 0,
      ),
      _QuestionData(
        question: l10n.quizQuestionTwo,
        options: <String>[
          l10n.quizTwoOptionOne,
          l10n.quizTwoOptionTwo,
          l10n.quizTwoOptionThree,
        ],
        correctAnswer: 0,
      ),
      _QuestionData(
        question: l10n.quizQuestionThree,
        options: <String>[
          l10n.quizThreeOptionOne,
          l10n.quizThreeOptionTwo,
          l10n.quizThreeOptionThree,
        ],
        correctAnswer: 2,
      ),
    ];
    var correctAnswers = 0;
    for (var index = 0; index < questions.length; index++) {
      if (answers[index] == questions[index].correctAnswer) correctAnswers++;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.miniAssessmentTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.quizProgress(correctAnswers)),
          const SizedBox(height: AppSpacing.md),
          for (var index = 0; index < questions.length; index++)
            _QuestionCard(
              title: '${index + 1}.',
              question: questions[index].question,
              options: questions[index].options,
              selectedAnswer: answers[index],
              correctAnswer: questions[index].correctAnswer,
              correctMessage: l10n.quizCorrect,
              incorrectMessage: l10n.quizTryAgain,
              onSelected: (answer) => onSelected(index, answer),
            ),
        ],
      ),
    );
  }
}

final class _QuestionData {
  const _QuestionData({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  final String question;
  final List<String> options;
  final int correctAnswer;
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.title,
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.correctMessage,
    required this.incorrectMessage,
    required this.onSelected,
  });

  final String title;
  final String question;
  final List<String> options;
  final int? selectedAnswer;
  final int correctAnswer;
  final String correctMessage;
  final String incorrectMessage;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final isCorrect = selectedAnswer == correctAnswer;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(question, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.md),
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
            Text(
              isCorrect ? correctMessage : incorrectMessage,
              style: TextStyle(
                color:
                    isCorrect
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}

class _LessonSection extends StatelessWidget {
  const _LessonSection({
    required this.title,
    required this.body,
    this.items = const <String>[],
    this.prompt,
  });

  final String title;
  final String body;
  final List<String> items;
  final String? prompt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: Theme.of(context).textTheme.bodyLarge),
          if (items.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('• ', style: Theme.of(context).textTheme.bodyLarge),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (prompt != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              prompt!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
