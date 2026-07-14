import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(professionalRepositoryProvider);

    return OraculoScaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: repo.templates.length,
        itemBuilder: (context, idx) {
          final item = repo.templates[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            child: ExpansionTile(
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Text(
                item.description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              leading: const Icon(Icons.article_outlined, color: Colors.blue),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.template,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: item.template));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Plantilla copiada al portapapeles.')),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy_all),
                        label: const Text('Copiar Plantilla'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
