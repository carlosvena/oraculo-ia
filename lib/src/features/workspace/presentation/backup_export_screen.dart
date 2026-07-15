import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/workspace/data/workspace_repository.dart';

class BackupExportScreen extends ConsumerStatefulWidget {
  const BackupExportScreen({super.key});

  @override
  ConsumerState<BackupExportScreen> createState() => _BackupExportScreenState();
}

class _BackupExportScreenState extends ConsumerState<BackupExportScreen> {
  final _importController = TextEditingController();

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  void _copyBackup() {
    final payload = ref.read(workspaceRepositoryProvider).generateBackupPayload();
    Clipboard.setData(ClipboardData(text: payload));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copia de seguridad copiada al portapapeles.')),
    );
  }

  void _importBackup() async {
    final input = _importController.text.trim();
    if (input.isEmpty) return;

    final success = await ref.read(workspaceStateProvider.notifier).importBackupPayload(input);
    if (success) {
      _importController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Respaldo importado y validado exitosamente!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Respaldo inválido o hash corrupto.')),
        );
      }
    }
  }

  void _copyWorkspaceMarkdown() {
    final repo = ref.read(workspaceRepositoryProvider);
    final buffer = StringBuffer();
    buffer.writeln('# Resumen de mi Workspace Personal - ORÁCULO IA');
    buffer.writeln();

    buffer.writeln('## Mis Notas');
    for (final n in repo.notes) {
      buffer.writeln('### ${n.title}');
      buffer.writeln(n.body);
      buffer.writeln();
    }

    buffer.writeln('## Mis Prompts Vault');
    for (final p in repo.prompts) {
      buffer.writeln('### ${p.title} (v${p.version})');
      buffer.writeln('```');
      buffer.writeln(p.promptText);
      buffer.writeln('```');
      buffer.writeln();
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workspace exportado a Markdown en el portapapeles.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Respaldos y Exportación'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección 1: Exportar Respaldo
          const Text('📤 Generar Copia de Seguridad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3C72))),
          const SizedBox(height: 8),
          const Text('Genera un archivo de respaldo codificado con verificación de hash sha256 de integridad para prevenir pérdidas de datos.'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _copyBackup,
            icon: const Icon(Icons.copy_all),
            label: const Text('Copiar Backup Completo'),
          ),
          const SizedBox(height: 24),

          // Sección 2: Importar Respaldo
          const Text('📥 Importar Copia de Seguridad', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3C72))),
          const SizedBox(height: 8),
          const Text('Pega la copia de seguridad aquí. Se verificará automáticamente el checksum sha256.'),
          const SizedBox(height: 12),
          TextField(
            controller: _importController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Pega el JSON de respaldo aquí...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _importBackup,
            icon: const Icon(Icons.system_update_alt_rounded),
            label: const Text('Validar e Importar'),
          ),
          const SizedBox(height: 24),

          // Sección 3: Exportar Formato
          const Text('📄 Exportar en Formatos legibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3C72))),
          const SizedBox(height: 8),
          const Text('Exporta todas tus notas y prompts unificados en un único documento estructurado en formato Markdown.'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _copyWorkspaceMarkdown,
            icon: const Icon(Icons.article_rounded),
            label: const Text('Exportar Workspace a Markdown'),
          ),
        ],
      ),
    );
  }
}
