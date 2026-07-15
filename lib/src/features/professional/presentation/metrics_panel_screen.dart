import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/features/content/data/knowledge_engine.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';

class MetricsPanelScreen extends ConsumerWidget {
  const MetricsPanelScreen({super.key});

  Future<Map<String, dynamic>> _loadStaticMetrics() async {
    final raw = await rootBundle.loadString('knowledge/developer_metrics_v1.json');
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ke = KnowledgeEngine.instance;
    final prof = ref.read(professionalRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Interno de Métricas'),
        backgroundColor: const Color(0xFF1E3C72),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadStaticMetrics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error al cargar métricas de desarrollo.'));
          }

          final staticMetrics = snapshot.data!;
          final libLoc = staticMetrics['lib_loc'] ?? 0;
          final testLoc = staticMetrics['test_loc'] ?? 0;
          final libFiles = staticMetrics['lib_files'] ?? 0;
          final testFiles = staticMetrics['test_files'] ?? 0;
          final totalLoc = libLoc + testLoc;
          final modules = staticMetrics['modules'] ?? 0;
          final testsCount = staticMetrics['tests_count'] ?? 0;
          final coverage = staticMetrics['coverage_percent'] ?? 0.0;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Cabecera de Métricas de Desarrollo
              const Text(
                '💻 Métricas de Ingeniería y Código',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3C72)),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildMetricRow('Líneas de Código (lib/)', '$libLoc LOC ($libFiles archivos)'),
                      const Divider(),
                      _buildMetricRow('Líneas de Pruebas (test/)', '$testLoc LOC ($testFiles archivos)'),
                      const Divider(),
                      _buildMetricRow('Líneas Totales del Proyecto', '$totalLoc LOC'),
                      const Divider(),
                      _buildMetricRow('Cantidad de Módulos', '$modules'),
                      const Divider(),
                      _buildMetricRow('Pruebas Automatizadas', '$testsCount'),
                      const Divider(),
                      _buildMetricRow('Cobertura Estimada', '$coverage%'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Cabecera de Métricas de Contenido
              const Text(
                '📚 Métricas de Contenido y Academia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3C72)),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildMetricRow('Cursos Académicos', '${ke.academyCourses.length}'),
                      const Divider(),
                      _buildMetricRow('Misiones de Aprendizaje', '${ke.academyMissions.length}'),
                      const Divider(),
                      _buildMetricRow('Laboratorios Prácticos (AI Lab)', '${ke.promptExercises.length}'),
                      const Divider(),
                      _buildMetricRow('Proyectos Integradores', '${ke.projects.length}'),
                      const Divider(),
                      _buildMetricRow('Términos del Glosario', '${ke.terms.length}'),
                      const Divider(),
                      _buildMetricRow('Capítulos del Manual', '${ke.articles.length}'),
                      const Divider(),
                      _buildMetricRow('Prompts Profesionales', '${prof.prompts.length}'),
                      const Divider(),
                      _buildMetricRow('Casos Reales de Negocio', '${prof.cases.length}'),
                      const Divider(),
                      _buildMetricRow('Desafíos de Inferencia', '${prof.challenges.length}'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        ],
      ),
    );
  }
}
