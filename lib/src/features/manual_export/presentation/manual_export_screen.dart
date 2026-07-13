import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/presentation/knowledge_providers.dart';
import 'package:oraculo_ia/src/features/manual_export/domain/manual_export.dart';
import 'package:path_provider/path_provider.dart';

class ManualExportScreen extends ConsumerStatefulWidget {
  const ManualExportScreen({super.key});

  @override
  ConsumerState<ManualExportScreen> createState() => _ManualExportScreenState();
}

class _ManualExportScreenState extends ConsumerState<ManualExportScreen> {
  ExportScope scope = ExportScope.complete;
  double scale = 1.0;

  String _scopeName(ExportScope value) => switch (value) {
        ExportScope.complete => 'Todo el manual',
        ExportScope.chapter => 'Por capítulos',
        ExportScope.topic => 'Por temas de misiones',
        ExportScope.favorites => 'Mis favoritos',
        ExportScope.review => 'Conceptos para repasar',
      };

  void _showNotification(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = ref.watch(knowledgeProvider).value;

    return OraculoScaffold(
      body: ListView(
        children: [
          Text(
            'Manual Maestro',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Modo lectura nocturna y exportación offline.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Escala de lectura: ${(scale * 100).round()}%',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Slider(
            value: scale,
            min: 1.0,
            max: 2.0,
            divisions: 4,
            label: '${(scale * 100).round()}%',
            onChanged: (v) => setState(() => scale = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<ExportScope>(
            initialValue: scope,
            decoration: const InputDecoration(
              labelText: 'Alcance de la exportación',
            ),
            items: [
              for (final s in ExportScope.values)
                DropdownMenuItem(
                  value: s,
                  child: Text(_scopeName(s)),
                )
            ],
            onChanged: (v) => setState(() => scope = v!),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (content != null) ...[
            FilledButton(
              onPressed: () async {
                try {
                  final bytes = await const ManualExporter().pdf(content, scope: scope);
                  final directory = await getApplicationDocumentsDirectory();
                  final file = File('${directory.path}/oraculo_manual_maestro.pdf');
                  await file.writeAsBytes(bytes);
                  _showNotification('PDF guardado en: ${file.path}');
                } catch (e) {
                  _showNotification('Error al exportar PDF: $e');
                }
              },
              child: const Text('Exportar PDF'),
            ),
            const SizedBox(height: AppSpacing.xs),
            OutlinedButton(
              onPressed: () async {
                try {
                  final mdText = const ManualExporter().markdown(content, scope: scope);
                  await Clipboard.setData(ClipboardData(text: mdText));
                  _showNotification('Markdown copiado al portapapeles.');
                } catch (e) {
                  _showNotification('Error al copiar Markdown: $e');
                }
              },
              child: const Text('Exportar Markdown'),
            ),
            const SizedBox(height: AppSpacing.xs),
            OutlinedButton(
              onPressed: () async {
                try {
                  final htmlText = const ManualExporter().html(content, scope: scope);
                  final directory = await getApplicationDocumentsDirectory();
                  final file = File('${directory.path}/oraculo_manual.html');
                  await file.writeAsString(htmlText);
                  _showNotification('HTML guardado en: ${file.path}');
                } catch (e) {
                  _showNotification('Error al exportar HTML: $e');
                }
              },
              child: const Text('Exportar HTML'),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Vista de lectura rápida',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final article in content.articles)
              Card(
                child: ExpansionTile(
                  title: Text(article.title),
                  shape: const Border(),
                  childrenPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  children: [
                    Text(
                      article.body,
                      textScaler: TextScaler.linear(scale),
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
          ] else
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
