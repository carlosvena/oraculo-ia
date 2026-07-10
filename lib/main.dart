import 'package:flutter/widgets.dart';
import 'package:oraculo_ia/src/app/app.dart';
import 'package:oraculo_ia/src/bootstrap/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(bootstrap(const OraculoApp()));
}
