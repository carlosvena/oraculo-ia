import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';


final class SearchResultItem {
  const SearchResultItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.routePath,
  });

  final String type; // 'Curso', 'Misión', 'Manual', 'Glosario', 'Lab', 'Biblioteca', 'Proyecto'
  final String title;
  final String subtitle;
  final String routePath;
}

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _ke = KnowledgeEngine.instance;
  String _query = '';
  final List<SearchResultItem> _results = [];

  void _performSearch(String query) {
    _query = query.trim().toLowerCase();
    _results.clear();

    if (_query.isEmpty) {
      setState(() {});
      return;
    }

    // 1. Cursos
    for (final c in _ke.academyCourses) {
      if (c.title.toLowerCase().contains(_query) || c.description.toLowerCase().contains(_query)) {
        _results.add(SearchResultItem(
          type: 'Curso',
          title: c.title,
          subtitle: c.description,
          routePath: '/course-details/${c.id}',
        ));
      }
    }

    // 2. Misiones
    for (final m in _ke.academyMissions) {
      if (m.title.toLowerCase().contains(_query) || m.objective.toLowerCase().contains(_query)) {
        _results.add(SearchResultItem(
          type: 'Misión',
          title: m.title,
          subtitle: m.objective,
          routePath: '/academy-catalog',
        ));
      }
    }

    // 3. Manual
    for (final a in _ke.articles) {
      if (a.title.toLowerCase().contains(_query) || a.body.toLowerCase().contains(_query)) {
        _results.add(SearchResultItem(
          type: 'Manual',
          title: a.title,
          subtitle: a.body,
          routePath: '/review',
        ));
      }
    }

    // 4. Glosario
    for (final t in _ke.terms) {
      if (t.term.toLowerCase().contains(_query) || t.definition.toLowerCase().contains(_query)) {
        _results.add(SearchResultItem(
          type: 'Glosario',
          title: t.term,
          subtitle: t.definition,
          routePath: '/review',
        ));
      }
    }

    // 5. Laboratorios
    for (final ex in _ke.promptExercises) {
      if (ex.title.toLowerCase().contains(_query) || ex.why.toLowerCase().contains(_query)) {
        _results.add(SearchResultItem(
          type: 'Lab',
          title: ex.title,
          subtitle: ex.why,
          routePath: '/review',
        ));
      }
    }

    // 6. Biblioteca de Pensamiento
    for (final idea in _ke.thoughtLibrary.ideas) {
      if (idea.title.toLowerCase().contains(_query) || idea.body.toLowerCase().contains(_query)) {
        _results.add(SearchResultItem(
          type: 'Biblioteca',
          title: idea.title,
          subtitle: '${idea.author}: ${idea.body}',
          routePath: '/review',
        ));
      }
    }

    // 7. Proyectos
    for (final proj in _ke.projects) {
      if (proj.title.toLowerCase().contains(_query) || proj.objective.toLowerCase().contains(_query)) {
        _results.add(SearchResultItem(
          type: 'Proyecto',
          title: proj.title,
          subtitle: proj.objective,
          routePath: '/projects',
        ));
      }
    }

    // 8. Edición Profesional — Prompts
    final profRepo = ProfessionalRepository.instance;
    if (profRepo.isInitialized) {
      for (final p in profRepo.prompts) {
        if (p.title.toLowerCase().contains(_query) || p.objective.toLowerCase().contains(_query) || p.example.toLowerCase().contains(_query)) {
          _results.add(SearchResultItem(
            type: 'Prompt (Prof)',
            title: p.title,
            subtitle: p.objective,
            routePath: '/office-mode/prompts',
          ));
        }
      }

      // 9. Edición Profesional — Casos
      for (final c in profRepo.cases) {
        if (c.title.toLowerCase().contains(_query) || c.description.toLowerCase().contains(_query)) {
          _results.add(SearchResultItem(
            type: 'Caso (Prof)',
            title: c.title,
            subtitle: c.description,
            routePath: '/office-mode/cases',
          ));
        }
      }

      // 10. Edición Profesional — Plantillas
      for (final t in profRepo.templates) {
        if (t.title.toLowerCase().contains(_query) || t.description.toLowerCase().contains(_query)) {
          _results.add(SearchResultItem(
            type: 'Plantilla (Prof)',
            title: t.title,
            subtitle: t.description,
            routePath: '/office-mode/templates',
          ));
        }
      }

      // 11. Edición Profesional — Simuladores
      for (final s in profRepo.simulators) {
        if (s.title.toLowerCase().contains(_query) || s.scenario.toLowerCase().contains(_query)) {
          _results.add(SearchResultItem(
            type: 'Simulador (Prof)',
            title: s.title,
            subtitle: s.scenario,
            routePath: '/office-mode/simulators',
          ));
        }
      }

      // 12. Edición Profesional — Desafíos
      for (final ch in profRepo.challenges) {
        if (ch.title.toLowerCase().contains(_query) || ch.description.toLowerCase().contains(_query)) {
          _results.add(SearchResultItem(
            type: 'Desafío (Prof)',
            title: ch.title,
            subtitle: ch.description,
            routePath: '/office-mode/challenges',
          ));
        }
      }

      // 13. Edición Profesional — Recursos
      for (final g in profRepo.guides) {
        if (g.title.toLowerCase().contains(_query) || g.content.toLowerCase().contains(_query)) {
          _results.add(SearchResultItem(
            type: 'Recurso (Prof)',
            title: g.title,
            subtitle: g.content,
            routePath: '/office-mode/resources',
          ));
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OraculoScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera con campo de texto
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Búsqueda General',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscá cursos, misiones, manual, laboratorios...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _performSearch,
          ),
          const SizedBox(height: AppSpacing.md),

          // Lista de Resultados
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(
                      _query.isEmpty ? 'Escribí algo para comenzar a buscar' : 'No se encontraron resultados.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final item = _results[index];
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.type,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              item.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(height: 1.3),
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () => context.push(item.routePath),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
