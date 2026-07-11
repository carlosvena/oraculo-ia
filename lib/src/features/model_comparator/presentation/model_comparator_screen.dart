import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/model_comparator/data/model_catalog_reader.dart';
import 'package:oraculo_ia/src/features/model_comparator/domain/model_profile.dart';

class ModelComparatorScreen extends StatefulWidget { const ModelComparatorScreen({super.key}); @override State<ModelComparatorScreen> createState()=>_State(); }
class _State extends State<ModelComparatorScreen> {
  static const tasks=['redacción','investigación','programación','documentos','excel','razonamiento','imágenes','audio','automatización'];
  String task='redacción';
  final costs=<String,String>{};
  @override Widget build(BuildContext context)=>OraculoScaffold(body:FutureBuilder<List<ModelProfile>>(
    future: const ModelCatalogReader().load(),
    builder:(context,snapshot){
      if(snapshot.hasError) return Center(child:Text('No pudimos validar el catálogo: ${snapshot.error}'));
      if(!snapshot.hasData) return const Center(child:CircularProgressIndicator());
      final values=recommendModels(snapshot.data!,task);
      return ListView(children:[
        Text('Comparador de modelos',style:Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height:8), const Text('Elegí por tarea, riesgo y contexto. Los datos temporales indican su fecha y fuente.'),
        const SizedBox(height:16), DropdownButtonFormField<String>(initialValue:task,decoration:const InputDecoration(labelText:'Tarea',border:OutlineInputBorder()),items:[for(final value in tasks) DropdownMenuItem(value:value,child:Text(value))],onChanged:(value)=>setState(()=>task=value!)),
        const SizedBox(height:16), for(final model in values) Card(child:ExpansionTile(
          title:Text(model.name), subtitle:Text(model.verified?'Revisado el 11/07/2026':'REQUIERE VERIFICACIÓN'),
          childrenPadding:const EdgeInsets.all(16),children:[
            Text(model.what), const SizedBox(height:12), _Field('Fortalezas',model.strengths.join('\n• ')), _Field('Limitaciones',model.limits.join('\n• ')), _Field('Cuándo no usarlo',model.avoid), _Field('Privacidad y datos',model.privacy), _Field('Disponibilidad',model.availability), _Field('Modelos relacionados',model.related.join(', ')),
            TextFormField(initialValue:costs[model.id]??'Verificar precio vigente',decoration:const InputDecoration(labelText:'Costo (campo local editable)'),onChanged:(value)=>costs[model.id]=value),
            const SizedBox(height:8), SelectableText('Fuente: ${model.source}',style:Theme.of(context).textTheme.bodySmall),
            const SizedBox(height:8), Text('Ejercicio: justificá por qué ${model.name} sería o no adecuado para $task considerando datos, verificación y costo.'),
          ]))
      ]);
    },
  ));
}
class _Field extends StatelessWidget { const _Field(this.title,this.value); final String title,value; @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:Theme.of(context).textTheme.titleSmall),Text('• $value')])); }
