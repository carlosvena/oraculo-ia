import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart' as domain;

class LessonBlock extends StatelessWidget {
  const LessonBlock({required this.block, this.child, super.key});

  final domain.LessonBlock block;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final visual = _visualFor(block.type, colors);

    return Card(
      margin: EdgeInsets.zero,
      color: visual.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: visual.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(visual.icon, size: 30, color: visual.foreground),
            const SizedBox(height: AppSpacing.lg),
            Text(
              block.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: visual.foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(block.content, style: Theme.of(context).textTheme.bodyLarge),
            if (block.items.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              for (final item in block.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: visual.foreground,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
            ],
            if (block.prompt != null &&
                !block.prompt!.startsWith('Leer más:')) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: visual.foreground.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  block.prompt!,
                  style: TextStyle(
                    color: visual.foreground,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
            if (block.prompt?.startsWith('Leer más:') ?? false) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () {
                  final first =
                      block.prompt!
                          .substring('Leer más:'.length)
                          .trim()
                          .split(' · ')
                          .first;
                  final id = switch (first) {
                    'LLM' => 'llm',
                    'Prompt' => 'prompt',
                    'Token' => 'token',
                    'Ventana de contexto' => 'context-window',
                    'Agente de IA' => 'agent',
                    _ => 'llm',
                  };
                  context.push('/dictionary?term=$id');
                },
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('LEER MÁS'),
              ),
            ],
            if (child != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              child!,
            ],
          ],
        ),
      ),
    );
  }

  _BlockVisual _visualFor(domain.LessonBlockType type, ColorScheme colors) {
    return switch (type) {
      domain.LessonBlockType.title => _BlockVisual(
        Icons.auto_awesome_rounded,
        colors.primaryContainer,
        colors.primary,
        colors.primary.withValues(alpha: 0.35),
      ),
      domain.LessonBlockType.text => _BlockVisual(
        Icons.menu_book_rounded,
        colors.surfaceContainer,
        colors.primary,
        colors.outlineVariant,
      ),
      domain.LessonBlockType.analogy => _BlockVisual(
        Icons.lightbulb_outline_rounded,
        colors.tertiaryContainer.withValues(alpha: 0.35),
        colors.tertiary,
        colors.tertiary.withValues(alpha: 0.35),
      ),
      domain.LessonBlockType.example => _BlockVisual(
        Icons.work_outline_rounded,
        colors.secondaryContainer.withValues(alpha: 0.35),
        colors.secondary,
        colors.secondary.withValues(alpha: 0.35),
      ),
      domain.LessonBlockType.challenge => _BlockVisual(
        Icons.science_outlined,
        colors.surfaceContainerHigh,
        colors.primary,
        colors.primary.withValues(alpha: 0.35),
      ),
      domain.LessonBlockType.quiz => _BlockVisual(
        Icons.quiz_outlined,
        colors.surfaceContainerHigh,
        colors.tertiary,
        colors.tertiary.withValues(alpha: 0.35),
      ),
      domain.LessonBlockType.summary => _BlockVisual(
        Icons.fact_check_outlined,
        colors.primaryContainer.withValues(alpha: 0.45),
        colors.primary,
        colors.primary.withValues(alpha: 0.35),
      ),
    };
  }
}

final class _BlockVisual {
  const _BlockVisual(this.icon, this.background, this.foreground, this.border);

  final IconData icon;
  final Color background;
  final Color foreground;
  final Color border;
}
