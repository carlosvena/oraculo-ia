import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/model_comparator/data/model_catalog_reader.dart';
import 'package:oraculo_ia/src/features/model_comparator/domain/model_profile.dart';

class ModelComparatorScreen extends StatefulWidget {
  const ModelComparatorScreen({super.key});

  @override
  State<ModelComparatorScreen> createState() => _ModelComparatorScreenState();
}

class _ModelComparatorScreenState extends State<ModelComparatorScreen> {
  static const tasks = [
    'redacción',
    'investigación',
    'programación',
    'documentos',
    'excel',
    'razonamiento',
    'imágenes',
    'audio',
    'automatización',
  ];

  String task = 'redacción';
  final costs = <String, String>{};

  @override
  Widget build(BuildContext context) {
    return OraculoScaffold(
      body: FutureBuilder<List<ModelProfile>>(
        future: const ModelCatalogReader().load(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No pudimos cargar el catálogo: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final values = recommendModels(snapshot.data!, task);
          return ListView(
            children: [
              Text(
                'Comparador de modelos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Elegí por tarea, riesgo y contexto. Los datos temporales indican su fecha y fuente.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                initialValue: task,
                decoration: const InputDecoration(labelText: 'Tarea'),
                items: [
                  for (final value in tasks)
                    DropdownMenuItem(value: value, child: Text(value))
                ],
                onChanged: (value) => setState(() => task = value!),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final model in values)
                Card(
                  child: ExpansionTile(
                    title: Text(model.name),
                    subtitle: Text(
                      model.verified ? 'Revisado el 11/07/2026' : 'Requiere verificación',
                      style: TextStyle(
                        color: model.verified ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    shape: const Border(),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            model.what,
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ),
                      _Field(title: 'Fortalezas', value: model.strengths.join('\n• ')),
                      _Field(title: 'Limitaciones', value: model.limits.join('\n• ')),
                      _Field(title: 'Cuándo no usarlo', value: model.avoid),
                      _Field(title: 'Privacidad y datos', value: model.privacy),
                      _Field(title: 'Disponibilidad', value: model.availability),
                      _Field(title: 'Modelos relacionados', value: model.related.join(', ')),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        initialValue: costs[model.id] ?? 'Verificar precio vigente',
                        decoration: const InputDecoration(
                          labelText: 'Costo (campo local editable)',
                        ),
                        onChanged: (value) => costs[model.id] = value,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SelectableText(
                          'Fuente: ${model.source}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ejercicio: justificá por qué ${model.name} sería o no adecuado para $task considerando datos, verificación y costo.',
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '• $value',
              style: const TextStyle(height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}
