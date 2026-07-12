import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/src/design_system/components/oraculo_scaffold.dart';
import 'package:oraculo_ia/src/features/content/presentation/knowledge_providers.dart';
import 'package:oraculo_ia/src/features/manual_export/domain/manual_export.dart';
import 'package:path_provider/path_provider.dart';

class ManualExportScreen extends ConsumerStatefulWidget {
  const ManualExportScreen({super.key});
  @override ConsumerState<ManualExportScreen> createState()=>_State();
}
class _State extends ConsumerState<ManualExportScreen>{
  ExportScope scope=ExportScope.complete; double scale=1; String message='';
  @override Widget build(BuildContext context){
    final content=ref.watch(knowledgeProvider).value;
    return OraculoScaffold(body:ListView(children:[
      Text('Manual Maestro',style:Theme.of(context).textTheme.headlineMedium),
      const Text('Modo lectura nocturna · exportación offline'),
      Slider(value:scale,min:1,max:2,divisions:4,label:'${(scale*100).round()}%',onChanged:(v)=>setState(()=>scale=v)),
      DropdownButtonFormField<ExportScope>(initialValue:scope,items:[for(final s in ExportScope.values)DropdownMenuItem(value:s,child:Text(s.name))],onChanged:(v)=>setState(()=>scope=v!)),
      const SizedBox(height:12),
      if(content!=null)...[
        FilledButton(onPressed:()async{final bytes=await const ManualExporter().pdf(content,scope:scope);final file=File('${(await getApplicationDocumentsDirectory()).path}/oraculo_manual_maestro.pdf');await file.writeAsBytes(bytes);setState(()=>message='PDF guardado en ${file.path}');},child:const Text('EXPORTAR PDF')),
        OutlinedButton(onPressed:()async{await Clipboard.setData(ClipboardData(text:const ManualExporter().markdown(content,scope:scope)));setState(()=>message='Markdown copiado');},child:const Text('EXPORTAR MARKDOWN')),
        OutlinedButton(onPressed:()async{final file=File('${(await getApplicationDocumentsDirectory()).path}/oraculo_manual.html');await file.writeAsString(const ManualExporter().html(content,scope:scope));setState(()=>message='HTML guardado en ${file.path}');},child:const Text('EXPORTAR HTML')),
        const Divider(),Text('Vista de lectura',style:Theme.of(context).textTheme.titleLarge),
        for(final article in content.articles) ExpansionTile(title:Text(article.title),children:[Padding(padding:const EdgeInsets.all(12),child:Text(article.body,textScaler:TextScaler.linear(scale)))]),
        Text(message),
      ] else const Center(child:CircularProgressIndicator()),
    ]));
  }
}
