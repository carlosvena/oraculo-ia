import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/professional/data/professional_repository.dart';
import 'package:oraculo_ia/src/features/professional/domain/professional_models.dart';

class SimulatorsScreen extends ConsumerStatefulWidget {
  const SimulatorsScreen({super.key});

  @override
  ConsumerState<SimulatorsScreen> createState() => _SimulatorsScreenState();
}

class _SimulatorsScreenState extends ConsumerState<SimulatorsScreen> {
  ProfessionalSimulator? _activeSim;
  String? _selectedModel;
  final _promptController = TextEditingController();
  final _checkedItems = <String>{};
  int? _finalScore;
  bool _submitted = false;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _resetSimulator(ProfessionalSimulator sim) {
    setState(() {
      _activeSim = sim;
      _selectedModel = null;
      _promptController.clear();
      _checkedItems.clear();
      _finalScore = null;
      _submitted = false;
    });
  }

  void _submitSimulation() {
    if (_activeSim == null || _selectedModel == null) return;

    final sim = _activeSim!;
    
    // Calcular score
    int score = 0;
    
    // 1. Modelo correcto (40 puntos)
    if (_selectedModel == sim.correctModel) {
      score += 40;
    }

    // 2. Elementos de verificación checklist (40 puntos prorrateados)
    final itemsCount = sim.verificationItems.length;
    if (itemsCount > 0) {
      final checkedCount = _checkedItems.length;
      score += ((checkedCount / itemsCount) * 40).round();
    }

    // 3. Prompt no vacío y con cuerpo razonable (20 puntos)
    final promptLen = _promptController.text.trim().length;
    if (promptLen > 25) {
      score += 20;
    } else if (promptLen > 0) {
      score += 10;
    }

    setState(() {
      _finalScore = score;
      _submitted = true;
    });

    // Guardar en el repositorio local
    ref.read(professionalStateProvider.notifier).recordSimulatorScore(sim.id, score);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(professionalRepositoryProvider);
    final state = ref.watch(professionalStateProvider);

    if (_activeSim != null) {
      return _buildInteractiveView(_activeSim!);
    }

    return OraculoScaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: repo.simulators.length,
        itemBuilder: (context, idx) {
          final sim = repo.simulators[idx];
          final prevScore = state.simulatorScores[sim.id];

          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            child: ListTile(
              leading: const Icon(Icons.psychology_outlined, color: Colors.purple, size: 36),
              title: Text(sim.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(
                prevScore != null ? 'Puntuación anterior: $prevScore%' : 'No realizado aún',
                style: TextStyle(color: prevScore != null ? Colors.green : Colors.grey, fontSize: 12),
              ),
              trailing: ElevatedButton(
                onPressed: () => _resetSimulator(sim),
                child: Text(prevScore != null ? 'Reintentar' : 'Iniciar'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractiveView(ProfessionalSimulator sim) {
    return OraculoScaffold(
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            _activeSim = null;
          });
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Botón volver
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _activeSim = null),
                ),
                const Text('Volver a simuladores', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Tarjeta de Escenario
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.assignment_rounded, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('CASO A RESOLVER:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      sim.scenario,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Paso 1: Selección de IA
            const Text('Paso 1: ¿Qué modelo de IA local utilizarías?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: sim.modelOptions.map((opt) {
                final isSelected = opt == _selectedModel;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(opt),
                      selected: isSelected,
                      onSelected: _submitted
                          ? null
                          : (val) {
                              setState(() {
                                _selectedModel = opt;
                              });
                            },
                    ),
                  ),
                );
              }).toList(),
            ),
            
            // Explicación de la elección si el modelo está seleccionado
            if (_selectedModel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Text(
                  sim.modelExplanations[_selectedModel] ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),

            // Paso 2: Redactar prompt
            const Text('Paso 2: Diseña tu metaprompt offline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _promptController,
              maxLines: 4,
              enabled: !_submitted,
              decoration: InputDecoration(
                hintText: 'Escribe tu instrucción y restricciones aquí...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Paso 3: Criterios de verificación
            const Text('Paso 3: Rúbrica y lista de verificación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: AppSpacing.xs),
            ...sim.verificationItems.map((item) {
              final isChecked = _checkedItems.contains(item);
              return CheckboxListTile(
                title: Text(item, style: const TextStyle(fontSize: 12)),
                value: isChecked,
                dense: true,
                onChanged: _submitted
                    ? null
                    : (val) {
                        setState(() {
                          if (val == true) {
                            _checkedItems.add(item);
                          } else {
                            _checkedItems.remove(item);
                          }
                        });
                      },
              );
            }),
            const SizedBox(height: AppSpacing.lg),

            // Botón o resultado
            if (!_submitted)
              FilledButton.icon(
                onPressed: (_selectedModel != null && _promptController.text.isNotEmpty)
                    ? _submitSimulation
                    : null,
                icon: const Icon(Icons.rocket_launch_rounded),
                label: const Text('Enviar para Evaluación'),
              )
            else ...[
              Card(
                color: _finalScore! >= 80 ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: _finalScore! >= 80 ? Colors.green : Colors.amber,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Text(
                        '¡Evaluación Completada!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _finalScore! >= 80 ? Colors.green : Colors.amber,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'PUNTUACIÓN OBTENIDA: $_finalScore / 100',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _finalScore! >= 80 
                          ? 'Excelente desempeño. Seleccionaste la estrategia correcta y verificaste los controles fundamentales.' 
                          : 'Buen intento, pero revisa si elegiste el modelo óptimo o si omitiste controles de salida cruciales.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _activeSim = null;
                  });
                },
                child: const Text('Terminar Simulación'),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
