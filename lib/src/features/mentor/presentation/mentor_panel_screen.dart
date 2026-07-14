import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/mentor/data/mentor_engine.dart';
import 'package:oraculo_ia/src/features/mentor/domain/llm_adapters.dart';

class MentorPanelScreen extends StatefulWidget {
  const MentorPanelScreen({super.key});

  @override
  State<MentorPanelScreen> createState() => _MentorPanelScreenState();
}

class _MentorPanelScreenState extends State<MentorPanelScreen> {
  final _engine = MentorEngine.instance;

  // Parámetros del planificador
  double _timeMinutes = 30.0;
  String _selectedGoal = 'Aprender Prompt Engineering';
  StudyPlan? _generatedPlan;

  // Estado del simulador de adaptadores de IA
  String _selectedAdapter = 'Gemini';
  String _simulatedOutput = '';
  String _testConcept = 'prompts';
  String _testStyle = 'analogia';

  @override
  Widget build(BuildContext context) {
    final profile = _engine.profile;
    final rec = _engine.getRecommendation();
    final totalConcepts = profile.learnedConcepts.length + profile.pendingConcepts.length;
    final progressPct = totalConcepts > 0 ? profile.learnedConcepts.length / totalConcepts : 0.0;

    return OraculoScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          // Cabecera Premium
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mentor Inteligente',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text(
                    'Tu tutor pedagógico offline y adaptativo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Tarjeta de Recomendación del Día (Módulo 2)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'RECOMENDACIÓN DEL DÍA',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sugerencia: ${rec.type.toUpperCase()} - ${rec.target}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    rec.reason,
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _engine.acceptRecommendation(rec);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Recomendación aceptada y registrada en memoria.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Aceptar Recomendación'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Métricas Pedagógicas (Módulo 1)
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  context,
                  'Horas estudiadas',
                  '${profile.hoursStudied.toStringAsFixed(1)}h',
                  Icons.timer_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildMetricTile(
                  context,
                  'Dificultad adaptativa',
                  profile.difficulty,
                  Icons.align_vertical_bottom,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Progreso General de Conceptos
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
                        'Conceptos Dominados',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${profile.learnedConcepts.length} / $totalConcepts'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  LinearProgressIndicator(
                    value: progressPct,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 8,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: profile.learnedConcepts.map((c) {
                      return Chip(
                        avatar: const Icon(Icons.check, size: 14, color: Colors.green),
                        label: Text(c),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Fortalezas y Debilidades
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Fortalezas',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        profile.learnedConcepts.isEmpty
                            ? const Text('Estudia misiones para revelar fortalezas.', style: TextStyle(color: Colors.grey, fontSize: 13))
                            : Wrap(
                                spacing: 4,
                                children: profile.learnedConcepts.take(2).map((c) => Chip(label: Text(c))).toList(),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Debilidades / Errores',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        profile.frequentErrors.isEmpty
                            ? const Text('Sin errores registrados hoy.', style: TextStyle(color: Colors.grey, fontSize: 13))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: profile.frequentErrors.entries.map((e) {
                                  return Text('• ${e.key} (Fallos: ${e.value})', style: const TextStyle(fontSize: 13));
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // MÓDULO 6 — PLANIFICADOR INTELIGENTE
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Planificador Inteligente de Sesiones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Contanos de cuánto tiempo disponés y qué querés lograr para armar tu plan offline.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Tiempo disponible: ${_timeMinutes.round()} minutos'),
                  Slider(
                    value: _timeMinutes,
                    min: 10,
                    max: 120,
                    divisions: 11,
                    onChanged: (val) => setState(() => _timeMinutes = val),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedGoal,
                    decoration: const InputDecoration(labelText: 'Meta Pedagógica'),
                    items: const [
                      DropdownMenuItem(value: 'Aprender Prompt Engineering', child: Text('Aprender Prompt Engineering')),
                      DropdownMenuItem(value: 'Construir un agente conceptual', child: Text('Construir un agente conceptual')),
                      DropdownMenuItem(value: 'Repasar conceptos débiles', child: Text('Repasar conceptos débiles')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedGoal = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _generatedPlan = _engine.generatePlan(_timeMinutes, _selectedGoal);
                      });
                    },
                    child: const Text('Generar Plan de Estudio'),
                  ),
                  if (_generatedPlan != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Divider(),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Plan Propuesto (${_generatedPlan!.estimatedMinutes.round()} min):',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ..._generatedPlan!.steps.map((step) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(step, style: const TextStyle(height: 1.3)),
                        )),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // MÓDULO 7 — SIMULADOR DE ADAPTADORES LLM
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Simulador de Adaptadores de IA',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Comprobá los contratos y prompts estructurados para la integración futura de APIs comerciales.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _selectedAdapter,
                    decoration: const InputDecoration(labelText: 'Proveedor de LLM'),
                    items: const [
                      DropdownMenuItem(value: 'Gemini', child: Text('Gemini (Google)')),
                      DropdownMenuItem(value: 'OpenAI', child: Text('OpenAI')),
                      DropdownMenuItem(value: 'Claude', child: Text('Claude (Anthropic)')),
                      DropdownMenuItem(value: 'DeepSeek', child: Text('DeepSeek')),
                      DropdownMenuItem(value: 'Llama', child: Text('Llama (Meta)')),
                      DropdownMenuItem(value: 'Mistral', child: Text('Mistral')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedAdapter = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () async {
                      LlmentorAdapter adapter;
                      switch (_selectedAdapter) {
                        case 'OpenAI':
                          adapter = const OpenAiAdapter();
                          break;
                        case 'Claude':
                          adapter = const ClaudeAdapter();
                          break;
                        case 'DeepSeek':
                          adapter = const DeepSeekAdapter();
                          break;
                        case 'Llama':
                          adapter = const LlamaAdapter();
                          break;
                        case 'Mistral':
                          adapter = const MistralAdapter();
                          break;
                        case 'Gemini':
                        default:
                          adapter = const GeminiAdapter();
                          break;
                      }

                      final output = await adapter.requestExplanation(
                        concept: _testConcept,
                        style: _testStyle,
                        learnerContext: 'Nivel: ${profile.level}, Trabajo: ${profile.work}',
                      );
                      setState(() {
                        _simulatedOutput = output;
                      });
                    },
                    child: const Text('Simular Pedido de Explicación'),
                  ),
                  if (_simulatedOutput.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Text(
                        _simulatedOutput,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
