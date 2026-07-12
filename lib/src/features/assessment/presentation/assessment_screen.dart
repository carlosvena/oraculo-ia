import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/assessment/domain/assessment.dart';
import 'package:oraculo_ia/src/features/progress/data/local_learning_state.dart';

class AssessmentScreen extends ConsumerStatefulWidget {const AssessmentScreen({super.key});@override ConsumerState<AssessmentScreen> createState()=>_State();}
class _State extends ConsumerState<AssessmentScreen>{
  AssessmentTask task=assessmentTasks.first; final controller=TextEditingController(); AssessmentFeedback? feedback;
  @override void dispose(){controller.dispose();super.dispose();}
  @override Widget build(BuildContext context){final completed=ref.watch(learningStateProvider).value?.completed.length??0;final available=assessmentTasks.where((item)=>item.masteryCheckpoint==null||completed>=item.masteryCheckpoint!).toList();if(!available.contains(task))task=available.first;return OraculoScaffold(body:ListView(children:[
    Text('Evaluación real',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:8),const Text('Pensá, construí y explicá. La devolución automática es orientativa y siempre admite revisión personal.'),const SizedBox(height:16),
    DropdownButtonFormField<AssessmentTask>(initialValue:task,decoration:const InputDecoration(labelText:'Actividad',border:OutlineInputBorder()),items:[for(final item in available)DropdownMenuItem(value:item,child:Text(item.title))],onChanged:(value)=>setState((){task=value!;feedback=null;controller.clear();})),const SizedBox(height:16),
    Text(task.prompt,style:Theme.of(context).textTheme.titleMedium),const SizedBox(height:12),TextField(controller:controller,minLines:7,maxLines:14,decoration:const InputDecoration(labelText:'Tu respuesta',alignLabelWithHint:true,border:OutlineInputBorder())),const SizedBox(height:12),FilledButton(onPressed:()=>setState(()=>feedback=const LocalRubricEvaluator().evaluate(task,controller.text)),child:const Text('EVALUAR CON RÚBRICA LOCAL')),
    if(feedback case final result?)...[const SizedBox(height:16),LinearProgressIndicator(value:result.progress),const SizedBox(height:12),for(final item in result.criteria)ListTile(leading:Icon(item.met?Icons.check_circle:Icons.pending_outlined),title:Text(item.name),subtitle:Text(item.message)),Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Ejemplo de respuesta sólida',style:Theme.of(context).textTheme.titleMedium),const SizedBox(height:8),Text(task.solidExample)]))),Padding(padding:const EdgeInsets.symmetric(vertical:12),child:Text(result.disclaimer)),OutlinedButton.icon(onPressed:()=>ref.read(learningStateProvider.notifier).toggleFavorite('assessment:${task.id}'),icon:const Icon(Icons.bookmark_add_outlined),label:const Text('MARCAR PARA REVISIÓN PERSONAL'))]
  ]));}
}
