import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';

class VersionNewsScreen extends StatelessWidget {
  const VersionNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Novedades de esta Versión',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Versión 2.11.0 (Enterprise Foundation)',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.md),

          // Banner
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Más de 200 horas de contenido offline!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Hemos cargado el motor con contenido formativo real y profundo en todas las áreas de la IA. Explora cada sección a continuación.',
                    style: TextStyle(height: 1.3, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Secciones de Contenido Nuevo
          _buildNewsTile(
            context,
            title: '30 Misiones Completas',
            subtitle: 'Lecciones con explicaciones simples y profundas, ejemplos y autoevaluaciones.',
            icon: Icons.play_circle_filled_outlined,
            color: Colors.green,
            routePath: '/academy-catalog',
          ),
          _buildNewsTile(
            context,
            title: '150 Términos del Diccionario',
            subtitle: 'Glosario inteligente ampliado con analogías y errores frecuentes por término.',
            icon: Icons.book_outlined,
            color: Colors.blue,
            routePath: '/review', // Enlaza a repaso/glosario
          ),
          _buildNewsTile(
            context,
            title: '30 Capítulos del Manual Maestro',
            subtitle: 'Manual continuo de Prompting, Transformers y Mitigación de Alucinaciones.',
            icon: Icons.menu_book,
            color: Colors.orange,
            routePath: '/review',
          ),
          _buildNewsTile(
            context,
            title: '50 Laboratorios Completos',
            subtitle: 'Prácticas interactivas guiadas en Prompting, Excel, Automatización y Banca.',
            icon: Icons.science_outlined,
            color: Colors.purple,
            routePath: '/ai-lab',
          ),
          _buildNewsTile(
            context,
            title: '15 Proyectos de Ingeniería',
            subtitle: 'Entregables prácticos desde analizadores de informes hasta asistentes de supervisión bancaria.',
            icon: Icons.workspace_premium_outlined,
            color: Colors.amber,
            routePath: '/projects',
          ),
          _buildNewsTile(
            context,
            title: 'Biblioteca de Pensamiento Ampliada',
            subtitle: 'Citas textuales verificadas de referentes del sector con análisis de aplicación.',
            icon: Icons.lightbulb_outline,
            color: Colors.pink,
            routePath: '/thoughts',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String routePath,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, height: 1.3)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () => context.push(routePath),
      ),
    );
  }
}
