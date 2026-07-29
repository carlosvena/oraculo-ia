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
  @override void initState(){super.initState(); tts.setLanguage('es-AR'); tts.setCompletionHandler(()=>mounted?setState(()=>speaking=false):null);}
  @override void didUpdateWidget(covariant MentorVoicePanel oldWidget){super.didUpdateWidget(oldWidget); if(handsFree&&oldWidget.text!=widget.text){_speak();}}
  Future<void> _speak() async { await tts.setSpeechRate(speed); await tts.speak('${widget.title}. ${widget.text}'); if(mounted)setState(()=>speaking=true); }
  Future<void> _pause() async { await tts.pause(); if(mounted)setState(()=>speaking=false); }
  void _show(String title,String value)=>showModalBottomSheet<void>(context:context,showDragHandle:true,builder:(context)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:12),Text(value),const SizedBox(height:16),FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('ENTENDIDO'))]))));
  @override void dispose(){tts.stop();super.dispose();}

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
