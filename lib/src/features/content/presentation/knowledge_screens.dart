import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/domain/knowledge_content.dart';
import 'package:oraculo_ia/src/features/content/presentation/knowledge_providers.dart';
import 'package:oraculo_ia/src/features/lessons/domain/lesson.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class ManualScreen extends ConsumerStatefulWidget {
  const ManualScreen({required this.onOpenDictionary, super.key});
  final ValueChanged<String> onOpenDictionary;
  @override
  ConsumerState<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends ConsumerState<ManualScreen> {
  var query = '';
  @override
  Widget build(BuildContext context) {
    return OraculoScaffold(
      body: AsyncContent<KnowledgeContent>(
        value: ref.watch(knowledgeProvider),
        errorMessage: 'No pudimos abrir el manual offline.',
        retryLabel: 'REINTENTAR',
        onRetry: () => ref.invalidate(knowledgeProvider),
        data: (content) {
          final articles = content.search(query);
          return ListView(
            children: <Widget>[
              Text(
                'Manual offline',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Conceptos esenciales para aprender y trabajar con IA.',
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar en el manual',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => query = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Índice', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              for (final article in articles)
                _ArticleCard(article: article, onOpen: widget.onOpenDictionary),
              if (articles.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Text('No encontramos artículos para esa búsqueda.'),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onOpen});
  final KnowledgeArticle article;
  final ValueChanged<String> onOpen;
  @override
  Widget build(BuildContext context) => Consumer(
    builder: (context, ref, child) {
      final learning = ref.watch(learningStateProvider).value;
      final favorite =
          learning?.favorites.contains('article:${article.id}') ?? false;
      return Card(
        child: ExpansionTile(
          title: Text(article.title),
          trailing: IconButton(
            tooltip: favorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
            onPressed:
                () => ref
                    .read(learningStateProvider.notifier)
                    .toggleFavorite('article:${article.id}'),
          ),
          childrenPadding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            Text(article.body),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              children:
                  article.links
                      .map(
                        (id) => ActionChip(
                          label: Text(id),
                          onPressed: () => onOpen(id),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      );
    },
  );
}

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({this.initialTerm, super.key});
  final String? initialTerm;
  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  String? selected;
  @override
  void initState() {
    super.initState();
    selected = widget.initialTerm;
  }

  @override
  Widget build(BuildContext context) => OraculoScaffold(
    body: AsyncContent<KnowledgeContent>(
      value: ref.watch(knowledgeProvider),
      errorMessage: 'No pudimos abrir el diccionario.',
      retryLabel: 'REINTENTAR',
      onRetry: () => ref.invalidate(knowledgeProvider),
      data: (content) {
        final term = content.term(selected ?? content.terms.first.id);
        return ListView(
          children: <Widget>[
            Text(
              'Diccionario inteligente',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  content.terms
                      .map(
                        (item) => ChoiceChip(
                          label: Text(item.term),
                          selected: item.id == term.id,
                          onSelected: (_) => setState(() => selected = item.id),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      term.term,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(term.definition),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip:
                            (ref
                                        .watch(learningStateProvider)
                                        .value
                                        ?.favorites
                                        .contains('term:${term.id}') ??
                                    false)
                                ? 'Quitar de favoritos'
                                : 'Agregar a favoritos',
                        icon: Icon(
                          (ref
                                      .watch(learningStateProvider)
                                      .value
                                      ?.favorites
                                      .contains('term:${term.id}') ??
                                  false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed:
                            () => ref
                                .read(learningStateProvider.notifier)
                                .toggleFavorite('term:${term.id}'),
                      ),
                    ),
                    _Field('Explicación', term.explanation),
                    _Field('Analogía', term.analogy),
                    _Field('Ejemplo práctico', term.example),
                    _Field('Error frecuente', term.mistake),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Relacionado',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Wrap(
                      spacing: 8,
                      children:
                          term.related
                              .map(
                                (id) => ActionChip(
                                  label: Text(content.term(id).term),
                                  onPressed:
                                      () => setState(() => selected = id),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(value),
      ],
    ),
  );
}

class _Act {
  const _Act(this.title, this.subtitle, this.lessons);
  final String title;
  final String subtitle;
  final List<Lesson> lessons;
}

/// Agrupa las misiones en 4 actos narrativos, para que el catálogo se
/// vea como un recorrido con sentido, no como una lista plana de temas
/// sueltos. Se agrupa por prefijo de id, no por posición, para que el
/// orden se mantenga correcto aunque se agreguen más misiones después.
List<_Act> _groupIntoActs(List<Lesson> lessons) {
  bool isCore(Lesson l) => RegExp(r'-00[1-5]$').hasMatch(l.id);
  bool isMechanics(Lesson l) => RegExp(r'-(00[6-9]|01[0-5])$').hasMatch(l.id);
  const applicationIds = <String>{
    'lesson-work-016',
    'lesson-agents-avanzado-018',
    'lesson-costos-020',
    'lesson-rag-avanzado-021',
  };
  final acts = <_Act>[
    _Act(
      'Acto 1 · Fundamentos',
      'Las bases: qué es un modelo, cómo escribirle, qué es un LLM.',
      lessons.where(isCore).toList(),
    ),
    _Act(
      'Acto 2 · Cómo funciona por dentro',
      'Transformers, embeddings, entrenamiento, alucinaciones, RAG, agentes.',
      lessons.where(isMechanics).toList(),
    ),
    _Act(
      'Acto 3 · Aplicarlo a tu trabajo real',
      'Ya no son ejemplos genéricos: se adaptan a lo que vos hacés.',
      lessons.where((l) => applicationIds.contains(l.id)).toList(),
    ),
  ];
  final used = acts.expand((a) => a.lessons.map((l) => l.id)).toSet();
  acts.add(
    _Act(
      'Acto 4 · Criterio, ética y sociedad',
      'La idea que atraviesa toda la app: experimentar sin perder criterio propio.',
      lessons.where((l) => !used.contains(l.id)).toList(),
    ),
  );
  return acts.where((a) => a.lessons.isNotEmpty).toList();
}

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({required this.onOpenLesson, super.key});
  final ValueChanged<Lesson> onOpenLesson;
  @override
  Widget build(BuildContext context, WidgetRef ref) => OraculoScaffold(
    bottomNavIndex: 3,
    body: AsyncContent<KnowledgeContent>(
      value: ref.watch(knowledgeProvider),
      errorMessage: 'No pudimos abrir el catálogo.',
      retryLabel: 'REINTENTAR',
      onRetry: () => ref.invalidate(knowledgeProvider),
      data: (content) {
        final learning =
            ref.watch(learningStateProvider).value ?? const LearningState();
        final acts = _groupIntoActs(content.lessons);
        return ListView(
          children: <Widget>[
            Text('Catálogo', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'No son 24 temas sueltos: es un recorrido. Primero las bases, '
              'después cómo funciona por dentro, después cómo se aplica a tu '
              'trabajo real, y por último cómo pensarlo con criterio propio '
              '(la idea que atraviesa toda la app, no solo un tema más).',
            ),
            for (final act in acts) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(act.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                act.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final lesson in act.lessons)
                _MissionCard(
                  lesson: lesson,
                  duration: lesson.estimatedMinutes,
                  difficulty:
                      content.lessons.indexOf(lesson) < 2
                          ? 'Intensiva'
                          : 'Profesional',
                  status:
                      learning.completed.contains(lesson.id)
                          ? 'Completada'
                          : (content.lessons.indexOf(lesson) == 0 ||
                                  learning.completed.contains(
                                    content
                                        .lessons[content.lessons.indexOf(
                                              lesson,
                                            ) -
                                            1]
                                        .id,
                                  ))
                              ? 'Desbloqueada'
                              : 'Bloqueada',
                  concepts: lesson.concepts,
                  onTap:
                      (content.lessons.indexOf(lesson) == 0 ||
                              learning.completed.contains(
                                content
                                    .lessons[content.lessons.indexOf(lesson) -
                                        1]
                                    .id,
                              ))
                          ? () => onOpenLesson(lesson)
                        : null,
              ),
            ],
          ],
        );
      },
    ),
  );
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.lesson,
    required this.duration,
    required this.difficulty,
    required this.status,
    required this.concepts,
    this.onTap,
  });
  final Lesson lesson;
  final int duration;
  final String difficulty;
  final String status;
  final List<String> concepts;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      leading: Icon(
        onTap == null && status == 'Bloqueada'
            ? Icons.lock_outline
            : Icons.school_outlined,
      ),
      title: Text(lesson.title),
      subtitle: Text(
        '$status · $duration min · $difficulty\n${concepts.join(' · ')}',
      ),
      isThreeLine: true,
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
