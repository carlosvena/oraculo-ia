import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/async_content.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';
import 'package:oraculo_ia/src/features/thought_library/data/thought_library_reader.dart';
import 'package:oraculo_ia/src/features/thought_library/domain/thought_library.dart';

final thoughtLibraryProvider = FutureProvider<ThoughtLibrary>(
  (ref) => const ThoughtLibraryReader().load(),
);

class ThoughtLibraryScreen extends ConsumerStatefulWidget {
  const ThoughtLibraryScreen({super.key});
  @override
  ConsumerState<ThoughtLibraryScreen> createState() =>
      _ThoughtLibraryScreenState();
}

class _ThoughtLibraryScreenState extends ConsumerState<ThoughtLibraryScreen> {
  String query = '';
  String? topic;
  String? author;
  @override
  Widget build(BuildContext context) => OraculoScaffold(
    body: AsyncContent<ThoughtLibrary>(
      value: ref.watch(thoughtLibraryProvider),
      errorMessage: 'No pudimos abrir la biblioteca.',
      retryLabel: 'REINTENTAR',
      onRetry: () => ref.invalidate(thoughtLibraryProvider),
      data: (library) {
        final ideas = library.search(query, topic: topic, author: author);
        return ListView(
          children: <Widget>[
            Text(
              'Biblioteca de pensamiento',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ideas identificadas por tipo editorial. No imitan voces ni atribuyen frases inventadas.',
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar ideas',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: topic,
              decoration: const InputDecoration(labelText: 'Tema'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Todos los temas'),
                ),
                ...library.topics.map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                ),
              ],
              onChanged: (value) => setState(() => topic = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: author,
              decoration: const InputDecoration(labelText: 'Autor'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Todos los autores'),
                ),
                ...library.authors.map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                ),
              ],
              onChanged: (value) => setState(() => author = value),
            ),
            const SizedBox(height: 16),
            for (final idea in ideas) _IdeaCard(idea: idea),
          ],
        );
      },
    ),
  );
}

class _IdeaCard extends ConsumerWidget {
  const _IdeaCard({required this.idea});
  final ThoughtIdea idea;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite =
        ref
            .watch(learningStateProvider)
            .value
            ?.favorites
            .contains('thought:${idea.id}') ??
        false;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    idea.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
                  onPressed:
                      () => ref
                          .read(learningStateProvider.notifier)
                          .toggleFavorite('thought:${idea.id}'),
                ),
              ],
            ),
            Text('${idea.author} · ${idea.topic}'),
            const SizedBox(height: 8),
            Chip(label: Text(idea.kind)),
            const SizedBox(height: 8),
            Text(idea.body),
            const Divider(height: 24),
            Text(
              'Qué puedo aplicar yo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(idea.application),
            if (idea.source != null) ...[
              const SizedBox(height: 12),
              Text(
                '${idea.verification} · ${idea.date}\n${idea.context}\nFuente: ${idea.source}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children:
                  idea.concepts
                      .map((value) => Chip(label: Text(value)))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
