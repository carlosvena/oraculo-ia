import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oraculo_ia/src/app/app.dart';
import 'package:oraculo_ia/src/bootstrap/bootstrap.dart';
import 'package:oraculo_ia/src/core/error/friendly_crash_fallback.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // Si un widget revienta al construirse, mostramos una pantalla
      // amigable en vez de la pantalla roja/gris de error de Flutter.
      ErrorWidget.builder = (details) => const FriendlyCrashFallback();

      // Errores que Flutter reporta (build, layout, render) quedan
      // registrados en la consola pero ya no cuelgan la app entera.
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
      };

      runApp(bootstrap(const OraculoApp()));
    },
    (error, stack) {
      // Errores fuera del árbol de widgets (async, providers, etc.):
      // los dejamos registrados en vez de dejar que tumben la app.
      debugPrint('Error no capturado: $error');
    },
  );
}
