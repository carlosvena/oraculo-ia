import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

/// Panel del mentor, compacto por diseño: antes ocupaba varias filas fijas
/// (control de voz + interruptor + 3 botones grandes) y le dejaba muy poco
/// lugar a la pregunta/desafío real de la lección. Ahora es una sola fila;
/// todo lo demás vive en una hoja que se abre solo si se necesita.
class MentorVoicePanel extends ConsumerStatefulWidget {
  const MentorVoicePanel({required this.title, required this.text, super.key});
  final String title, text;
  @override ConsumerState<MentorVoicePanel> createState()=>_MentorVoicePanelState();
}
class _MentorVoicePanelState extends ConsumerState<MentorVoicePanel> {
  final tts=FlutterTts(); double speed=.48; bool speaking=false, handsFree=false;
  List<Map<String, String>> availableVoices = <Map<String, String>>[];
  String? selectedVoiceName;
  bool _voiceApplied = false;

  @override
  void initState(){
    super.initState();
    tts.setLanguage('es-AR');
    tts.setCompletionHandler(()=>mounted?setState(()=>speaking=false):null);
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    try {
      final raw = await tts.getVoices;
      final voices = <Map<String, String>>[];
      if (raw is List) {
        for (final item in raw) {
          if (item is Map) {
            final name = item['name']?.toString();
            final locale = item['locale']?.toString() ?? '';
            // Priorizamos voces en español para no abrumar con opciones
            // en idiomas que la persona probablemente no va a usar.
            if (name != null && locale.toLowerCase().startsWith('es')) {
              voices.add({'name': name, 'locale': locale});
            }
          }
        }
      }
      if (!mounted) return;
      setState(() => availableVoices = voices);
      final saved = ref.read(learningStateProvider).value?.mentorVoiceName ?? '';
      if (saved.isNotEmpty && voices.any((v) => v['name'] == saved)) {
        await _applyVoice(saved);
      }
    } catch (_) {
      // Algunos dispositivos no exponen la lista de voces; el mentor
      // sigue funcionando con la voz por defecto del sistema.
    }
  }

  Future<void> _applyVoice(String name) async {
    final voice = availableVoices.firstWhere(
      (v) => v['name'] == name,
      orElse: () => <String, String>{},
    );
    if (voice.isEmpty) return;
    await tts.setVoice({'name': voice['name']!, 'locale': voice['locale']!});
    if (mounted) setState(() => selectedVoiceName = name);
  }

  @override void didUpdateWidget(covariant MentorVoicePanel oldWidget){super.didUpdateWidget(oldWidget); if(handsFree&&oldWidget.text!=widget.text){_speak();}}
  Future<void> _speak() async {
    if (!_voiceApplied) {
      final saved = ref.read(learningStateProvider).value?.mentorVoiceName ?? '';
      if (saved.isNotEmpty) await _applyVoice(saved);
      _voiceApplied = true;
    }
    await tts.setSpeechRate(speed);
    await tts.speak('${widget.title}. ${widget.text}');
    if(mounted)setState(()=>speaking=true);
  }
  Future<void> _pause() async { await tts.pause(); if(mounted)setState(()=>speaking=false); }
  void _show(String title,String value)=>showModalBottomSheet<void>(context:context,showDragHandle:true,builder:(context)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:12),Text(value),const SizedBox(height:16),FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('ENTENDIDO'))]))));
  @override void dispose(){tts.stop();super.dispose();}

  void _openVoicePicker() {
    if (availableVoices.isEmpty) {
      _show(
        'Voces del mentor',
        'Tu celular no compartió una lista de voces en español. Podés '
            'igual cambiar la voz del sistema desde Ajustes > Accesibilidad '
            '> Conversión de texto a voz.',
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Elegí la voz del mentor', style: Theme.of(sheetContext).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Las voces vienen de tu celular. Probá un par: no todas suenan igual de bien en español.',
                style: Theme.of(sheetContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableVoices.length,
                  itemBuilder: (context, index) {
                    final voice = availableVoices[index];
                    final name = voice['name']!;
                    return RadioListTile<String>(
                      value: name,
                      groupValue: selectedVoiceName,
                      title: Text(name, overflow: TextOverflow.ellipsis),
                      subtitle: Text(voice['locale'] ?? ''),
                      onChanged: (value) async {
                        if (value == null) return;
                        await _applyVoice(value);
                        await ref
                            .read(learningStateProvider.notifier)
                            .setMentorVoice(value);
                        if (context.mounted) Navigator.pop(context);
                        await _speak();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openOptions(LearnerProfile profile) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Opciones del mentor', style: Theme.of(sheetContext).textTheme.titleMedium),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.record_voice_over_outlined),
                  title: const Text('Voz del mentor'),
                  subtitle: Text(
                    selectedVoiceName ?? 'Voz por defecto del sistema',
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openVoicePicker();
                  },
                ),
                Row(
                  children: [
                    const Text('Velocidad de lectura'),
                    Expanded(
                      child: Slider(
                        value: speed,
                        min: .3,
                        max: .7,
                        divisions: 4,
                        label: '${speed.toStringAsFixed(2)}x',
                        onChanged: (value) {
                          setSheetState(() => speed = value);
                          setState(() {});
                        },
                      ),
                    ),
                    Text('${speed.toStringAsFixed(2)}x'),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Modo manos libres'),
                  subtitle: const Text('Lee cada bloque al avanzar'),
                  value: handsFree,
                  onChanged: (value) {
                    setSheetState(() => handsFree = value);
                    setState(() {});
                    if (value) _speak();
                  },
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('Explicámelo de otra manera'),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _show('Otra perspectiva', mentorAlternative(widget.title));
                      },
                    ),
                    ActionChip(
                      label: const Text('Dame un ejemplo más difícil'),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _show('Ejemplo exigente', mentorHardExample(widget.title));
                      },
                    ),
                    ActionChip(
                      label: const Text('Aplicalo a mi trabajo'),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _show('Aplicación a tu trabajo', mentorWorkExample(widget.title, profile));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override Widget build(BuildContext context){
    final learningState = ref.watch(learningStateProvider).value ?? const LearningState();
    final profile = LearnerProfile.fromState(learningState);
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            IconButton(
              tooltip: speaking ? 'Pausar lectura' : 'Leer en voz alta',
              onPressed: speaking ? _pause : _speak,
              icon: Icon(speaking ? Icons.pause_circle : Icons.volume_up_outlined),
            ),
            const Expanded(
              child: Text('Mentor', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            IconButton(
              tooltip: 'Más opciones del mentor',
              onPressed: () => _openOptions(profile),
              icon: const Icon(Icons.tune),
            ),
          ],
        ),
      ),
    );
  }
}
