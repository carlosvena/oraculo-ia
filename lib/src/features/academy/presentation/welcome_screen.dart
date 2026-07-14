import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/knowledge_map/data/learning_engine.dart';

class AcademyWelcomeScreen extends StatelessWidget {
  const AcademyWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final le = LearningEngine.instance;

    // Inicializar grafos y datos si es necesario
    if (!le.isDetained && le.nodes.isEmpty) {
      le.initializeGraph();
    }

    final hours = le.actualHoursStudied > 0 ? le.actualHoursStudied : 4.5;
    final progressPct = hours / 10.0; // Meta de 10h semanales

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          // Banner Portada Espectacular (Módulo 8)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.school, size: 48, color: Colors.white),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'ACADEMIA IA',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Bienvenido a tu portal de maestría offline en Inteligencia Artificial.',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.push('/academy-catalog'),
                      child: const Text('Explorar Catálogo'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      onPressed: () => context.push('/knowledge-universe'),
                      child: const Text('Universo del Conocimiento'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // MÓDULO 8 — RESUMEN DE CONTENIDO EN PANTALLA PRINCIPAL
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Resumen del Universo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.new_releases_outlined, size: 16),
                        label: const Text('Novedades'),
                        onPressed: () => context.push('/version-news'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniStatBox('Cursos', '8'),
                      _buildMiniStatBox('Misiones', '30'),
                      _buildMiniStatBox('Labs', '50'),
                      _buildMiniStatBox('Proyectos', '15'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniStatBox('Capítulos', '34'),
                      _buildMiniStatBox('Glosario', '154'),
                      _buildMiniStatBox('Biblioteca', '30'),
                      _buildMiniStatBox('Modo', 'Offline'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Continuar Aprendiendo & Meta Semanal
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Continuar Aprendiendo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Misión 002: Anatomía de un prompt profesional',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        FilledButton.icon(
                          onPressed: () => context.push('/mentor-panel'),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Reanudar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meta Semanal (10h)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Invertido: ${hours.toStringAsFixed(1)} horas',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        LinearProgressIndicator(
                          value: progressPct,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${(progressPct * 100).round()}% completado',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Concepto del Día & Laboratorio Recomendado (Módulo 7)
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: AppSpacing.xs),
                      const Text(
                        'CONCEPTO DEL DÍA',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Few-Shot Prompting',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Técnica consistente en proveer de 2 a 5 ejemplos estructurados dentro del prompt para guiar el estilo, formato y restricciones de la respuesta del modelo autoregresivo.',
                    style: TextStyle(height: 1.3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Laboratorio Recomendado & Proyectos Activos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lab Recomendado',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Lab 02: Reducción de alucinaciones en tablas',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: () => context.push('/ai-lab'),
                          child: const Text('Comenzar Práctica'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Proyectos Activos',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Biblioteca de Prompts Bancarios',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: () => context.push('/projects'),
                          child: const Text('Ver Entregables'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Cursos recomendados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Text(
              'Cursos Recomendados para Carlos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          _buildRecommendedCourseCard(
            context,
            'Prompt Engineering Avanzado',
            'Intermedio · 250 min · 10 misiones',
            'Aprende a formular prompts complejos utilizando técnicas avanzadas de instrucción.',
            Colors.teal,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRecommendedCourseCard(
            context,
            'Sistemas de Agentes de IA',
            'Avanzado · 300 min · 10 misiones',
            'Diseña agentes autónomos capaces de razonar y ejecutar acciones locales.',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCourseCard(
    BuildContext context,
    String title,
    String subtitle,
    String desc,
    Color accent,
  ) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/academy-catalog'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(desc, style: const TextStyle(fontSize: 13, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatBox(String label, String val) {
    return Expanded(
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
