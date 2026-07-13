// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() {
  print('Iniciando el split de archivos de conocimiento...');

  // 1. Crear directorio knowledge/missions si no existe
  final missionsDir = Directory('knowledge/missions');
  if (!missionsDir.existsSync()) {
    missionsDir.createSync(recursive: true);
  }

  // 2. Cargar oraculo_content_v1.json
  final contentFile = File('knowledge/oraculo_content_v1.json');
  if (!contentFile.existsSync()) {
    print('Error: no se encontró oraculo_content_v1.json');
    exit(1);
  }
  final contentJson = jsonDecode(contentFile.readAsStringSync()) as Map<String, dynamic>;

  // 3. Extraer y escribir diccionario
  final dictionary = contentJson['dictionary'] as List<dynamic>;
  final dictFile = File('knowledge/dictionary_v1.json');
  dictFile.writeAsStringSync(
    JsonEncoder.withIndent('  ').convert({
      'schemaVersion': 1,
      'dictionary': dictionary,
    }),
  );
  print('Diccionario escrito con éxito.');

  // 4. Extraer y escribir manual
  final manual = contentJson['articles'] as List<dynamic>;
  final manualFile = File('knowledge/manual_v1.json');
  manualFile.writeAsStringSync(
    JsonEncoder.withIndent('  ').convert({
      'schemaVersion': 1,
      'articles': manual,
    }),
  );
  print('Manual escrito con éxito.');

  // 5. Extraer y escribir misiones 001 a 005
  final coreMissions = contentJson['missions'] as List<dynamic>;
  for (final mission in coreMissions) {
    final id = mission['id'] as String;
    final file = File('knowledge/missions/$id.json');
    file.writeAsStringSync(
      JsonEncoder.withIndent('  ').convert({
        'schemaVersion': 1,
        'mission': mission,
      }),
    );
    print('Misión core escrita: $id.json');
  }

  // 6. Cargar y procesar advanced_missions_v1.json
  final advFile = File('knowledge/advanced_missions_v1.json');
  if (advFile.existsSync()) {
    final advJson = jsonDecode(advFile.readAsStringSync()) as Map<String, dynamic>;
    final advMissions = advJson['missions'] as List<dynamic>;
    for (final mission in advMissions) {
      final id = mission['id'] as String;
      final file = File('knowledge/missions/$id.json');
      file.writeAsStringSync(
        JsonEncoder.withIndent('  ').convert({
          'schemaVersion': 1,
          'mission': mission,
        }),
      );
      print('Misión avanzada escrita: $id.json');
    }
  } else {
    print('Advertencia: no se encontró advanced_missions_v1.json');
  }

  print('Split de contenido finalizado con éxito.');
}
