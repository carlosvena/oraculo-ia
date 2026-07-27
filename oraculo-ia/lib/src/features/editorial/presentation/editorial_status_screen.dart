import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/editorial/domain/editorial_status.dart';

class EditorialStatusScreen extends StatelessWidget {
  const EditorialStatusScreen({super.key});
  @override
  Widget build(BuildContext context) => OraculoScaffold(
    body: FutureBuilder<List<EditorialItem>>(
      future: rootBundle.loadString('knowledge/editorial_manifest_v1.json').then((value) => const EditorialManifestReader().parse(value)),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error editorial: ${snapshot.error}'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final items = snapshot.data!;
        return ListView(children: [
          Text('Estado del conocimiento', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('${items.where((i) => i.state == EditorialState.verified).length} verificado · ${items.where((i) => i.state == EditorialState.reviewed).length} revisado · ${items.where((i) => i.state == EditorialState.outdated).length} desactualizado'),
          const SizedBox(height: 16),
          for (final item in items)
            Card(child: ExpansionTile(
              title: Text(item.title),
              subtitle: Text('${item.state.name} · v${item.version} · próxima revisión ${item.nextReview.day}/${item.nextReview.month}/${item.nextReview.year}'),
              childrenPadding: const EdgeInsets.all(16),
              children: [Text('Autor: ${item.author}\n${item.notes}\n\nFuentes:\n${item.sources.join('\n')}')],
            )),
        ]);
      },
    ),
  );
}
