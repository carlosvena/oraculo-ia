import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';

class MentorVoicePanel extends StatefulWidget {
  const MentorVoicePanel({required this.title, required this.text, super.key});
  final String title, text;
  @override State<MentorVoicePanel> createState()=>_MentorVoicePanelState();
}
class _MentorVoicePanelState extends State<MentorVoicePanel> {
  final tts=FlutterTts(); double speed=.48; bool speaking=false, handsFree=false;
  @override void initState(){super.initState(); tts.setLanguage('es-AR'); tts.setCompletionHandler(()=>mounted?setState(()=>speaking=false):null);}
  @override void didUpdateWidget(covariant MentorVoicePanel oldWidget){super.didUpdateWidget(oldWidget); if(handsFree&&oldWidget.text!=widget.text){_speak();}}
  Future<void> _speak() async { await tts.setSpeechRate(speed); await tts.speak('${widget.title}. ${widget.text}'); if(mounted)setState(()=>speaking=true); }
  Future<void> _pause() async { await tts.pause(); if(mounted)setState(()=>speaking=false); }
  void _show(String title,String value)=>showModalBottomSheet<void>(context:context,showDragHandle:true,builder:(context)=>SafeArea(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:Theme.of(context).textTheme.titleLarge),const SizedBox(height:12),Text(value),const SizedBox(height:16),FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('ENTENDIDO'))]))));
  @override void dispose(){tts.stop();super.dispose();}
  @override Widget build(BuildContext context)=>Card(child:Padding(padding:const EdgeInsets.all(12),child:Column(children:[
    Row(children:[IconButton(tooltip:speaking?'Pausar lectura':'Leer en voz alta',onPressed:speaking?_pause:_speak,icon:Icon(speaking?Icons.pause_circle:Icons.volume_up_outlined)),Expanded(child:Slider(value:speed,min:.3,max:.7,divisions:4,label:'${speed.toStringAsFixed(2)}x',onChanged:(value)=>setState(()=>speed=value))),Text('${speed.toStringAsFixed(2)}x')]),
    SwitchListTile(contentPadding:EdgeInsets.zero,title:const Text('Modo manos libres'),subtitle:const Text('Lee cada bloque al avanzar'),value:handsFree,onChanged:(value){setState(()=>handsFree=value);if(value)_speak();}),
    Wrap(spacing:6,children:[ActionChip(label:const Text('Explicámelo de otra manera'),onPressed:()=>_show('Otra perspectiva',mentorAlternative(widget.title))),ActionChip(label:const Text('Dame un ejemplo más difícil'),onPressed:()=>_show('Ejemplo exigente',mentorHardExample(widget.title))),ActionChip(label:const Text('Aplicalo a mi trabajo'),onPressed:()=>_show('Aplicación bancaria',mentorWorkExample(widget.title,const LearnerProfile())))])
  ])));
}
