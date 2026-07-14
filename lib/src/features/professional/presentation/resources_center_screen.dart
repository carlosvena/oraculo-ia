import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';
import 'package:oraculo_ia/src/features/professional/domain/professional_models.dart';

class ResourcesCenterScreen extends ConsumerWidget {
  const ResourcesCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(professionalRepositoryProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Centro de Recursos'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.import_contacts_rounded), text: 'Guías'),
              Tab(icon: Icon(Icons.playlist_add_check_rounded), text: 'Checklists'),
              Tab(icon: Icon(Icons.rule_folder_rounded), text: 'Procedimientos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña 1: Guías
            _buildGuidesTab(repo.guides),

            // Pestaña 2: Checklists
            _buildChecklistsTab(repo.checklists),

            // Pestaña 3: Procedimientos
            _buildProceduresTab(repo.procedures),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidesTab(List<ResourceGuide> list) {
    if (list.isEmpty) return const Center(child: Text('No hay guías registradas.'));
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final item = list[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: AppSpacing.sm),
                Text(item.content, style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChecklistsTab(List<ResourceChecklist> list) {
    if (list.isEmpty) return const Center(child: Text('No hay checklists registrados.'));
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final item = list[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: AppSpacing.sm),
                ...item.items.map((check) => CheckboxListTile(
                      title: Text(check, style: const TextStyle(fontSize: 12)),
                      value: false,
                      onChanged: (_) {},
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProceduresTab(List<ResourceProcedure> list) {
    if (list.isEmpty) return const Center(child: Text('No hay procedimientos registrados.'));
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final item = list[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: AppSpacing.sm),
                ...item.steps.asMap().entries.map((entry) {
                  final sIdx = entry.key + 1;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$sIdx. ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue)),
                        Expanded(child: Text(step, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
