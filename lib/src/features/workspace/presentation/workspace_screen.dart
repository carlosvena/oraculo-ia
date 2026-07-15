import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workspaceStateProvider);

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Cabecera Principal
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.rocket_launch_rounded, color: Colors.cyanAccent, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'Mi Workspace',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Crea prompts, registra experimentos, escribe notas markdown y almacena documentos. Todo almacenado 100% local y offline.',
                  style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Cuadrícula de Estadísticas
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.1,
            children: [
              _buildStatCard(context, 'Notas Guardadas', '${state.notes.length}', Icons.article_rounded, Colors.blue),
              _buildStatCard(context, 'Prompt Vault', '${state.prompts.length}', Icons.library_books_rounded, Colors.purple),
              _buildStatCard(context, 'Experimentos', '${state.experiments.length}', Icons.science_rounded, Colors.green),
              _buildStatCard(context, 'Favoritos', '${state.favoriteItemIds.length}', Icons.star_rounded, Colors.amber),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Opciones de Navegación del Workspace
          Text(
            'Herramientas Personales',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildMenuTile(
            context,
            title: 'Notebook (Notas Markdown)',
            subtitle: 'Redacta textos con soporte de formato markdown y autoguardado.',
            icon: Icons.edit_note_rounded,
            color: Colors.blue,
            route: '/workspace/notebook',
          ),
          _buildMenuTile(
            context,
            title: 'Prompt Vault',
            subtitle: 'Tu base de prompts personalizados categorizados y versionados.',
            icon: Icons.vpn_key_rounded,
            color: Colors.purple,
            route: '/workspace/vault',
          ),
          _buildMenuTile(
            context,
            title: 'Registro de Experimentos',
            subtitle: 'Documenta la hipótesis, el prompt y los resultados de tus pruebas.',
            icon: Icons.biotech_rounded,
            color: Colors.green,
            route: '/workspace/experiments',
          ),
          _buildMenuTile(
            context,
            title: 'Mis Documentos',
            subtitle: 'Almacena y clasifica documentos de IA, trabajo y proyectos.',
            icon: Icons.folder_shared_rounded,
            color: Colors.orange,
            route: '/workspace/documents',
          ),
          _buildMenuTile(
            context,
            title: 'Respaldos y Exportación',
            subtitle: 'Exporta tu espacio de trabajo en PDF/Markdown o importa backups.',
            icon: Icons.settings_backup_restore_rounded,
            color: Colors.teal,
            route: '/workspace/backup',
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        onTap: () => context.push(route),
      ),
    );
  }
}
