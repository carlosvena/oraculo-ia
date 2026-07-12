import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/mentor/domain/learner_profile.dart';

class LearnerProfileScreen extends StatelessWidget {
  const LearnerProfileScreen({super.key});
  @override Widget build(BuildContext context){const profile=LearnerProfile();return OraculoScaffold(body:ListView(children:[
    Text('Perfil de Carlos',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:8),const Text('Este perfil vive solo en el dispositivo y adapta ejemplos editoriales. No se envía a servicios externos.'),const SizedBox(height:16),
    _Item('Nivel actual',profile.level),_Item('Trabajo',profile.work),_Item('Recorrido',profile.intensive?'Modo intensivo':'Modo esencial'),_Item('Dificultad',profile.difficulty),_Item('Intereses',profile.interests.join(' · ')),_Item('Temas prioritarios',profile.priorities.join(' · ')),
  ]));}
}
class _Item extends StatelessWidget {const _Item(this.title,this.value);final String title,value;@override Widget build(BuildContext context)=>Card(child:ListTile(title:Text(title),subtitle:Text(value)));}
