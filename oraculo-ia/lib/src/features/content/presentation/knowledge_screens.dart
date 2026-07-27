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

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({required this.onOpenLesson, super.key});
  final ValueChanged<Lesson> onOpenLesson;
  @override
  Widget build(BuildContext context, WidgetRef ref) => OraculoScaffold(
    body: AsyncContent<KnowledgeContent>(
      value: ref.watch(knowledgeProvider),
      errorMessage: 'No pudimos abrir el catálogo.',
      retryLabel: 'REINTENTAR',
      onRetry: () => ref.invalidate(knowledgeProvider),
      data: (content) {
        final learning =
            ref.watch(learningStateProvider).value ?? const LearningState();
        return ListView(
          children: <Widget>[
            Text('Catálogo', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Misiones disponibles para desarrollar criterio profesional.',
            ),
            const SizedBox(height: AppSpacing.lg),
            for (var index = 0; index < content.lessons.length; index++)
              _MissionCard(
                lesson: content.lessons[index],
                duration: content.lessons[index].estimatedMinutes,
                difficulty: index < 2 ? 'Intensiva' : 'Profesional',
                status:
                    learning.completed.contains(content.lessons[index].id)
                        ? 'Completada'
                        : index == 0 ||
                            learning.completed.contains(
                              content.lessons[index - 1].id,
                            )
                        ? 'Desbloqueada'
                        : 'Bloqueada',
                concepts: content.lessons[index].concepts,
                onTap:
                    index == 0 ||
                            learning.completed.contains(
                              content.lessons[index - 1].id,
                            )
                        ? () => onOpenLesson(content.lessons[index])
                        : null,
              ),
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
