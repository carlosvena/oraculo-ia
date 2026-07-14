import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/editorial/domain/editorial_status.dart';

class EditorialStatusScreen extends StatelessWidget {
  const EditorialStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OraculoScaffold(
      body: FutureBuilder<List<EditorialItem>>(
        future: rootBundle
            .loadString('knowledge/editorial_manifest_v1.json')
            .then((value) => const EditorialManifestReader().parse(value)),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error editorial: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          final verifiedCount = items.where((i) => i.state == EditorialState.verified).length;
          final reviewedCount = items.where((i) => i.state == EditorialState.reviewed).length;
          final outdatedCount = items.where((i) => i.state == EditorialState.outdated).length;

          return ListView(
            children: [
              Text(
                'Estado del conocimiento',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$verifiedCount verificado · $reviewedCount revisado · $outdatedCount desactualizado',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/creator-studio'),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Abrir Creator Studio'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final item in items)
                Card(
                  child: ExpansionTile(
                    title: Text(item.title),
                    subtitle: Text(
                      '${item.state.name} · v${item.version} · próxima revisión ${item.nextReview.day}/${item.nextReview.month}/${item.nextReview.year}',
                    ),
                    shape: const Border(),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Autor: ${item.author}\n\nDetalles:\n${item.notes}\n\nFuentes:\n${item.sources.map((s) => '• $s').join('\n')}',
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
