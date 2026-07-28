import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/app/router/app_route.dart';
import 'package:oraculo_ia/src/app/router/app_router.dart';
import 'package:oraculo_ia/src/app/theme/app_theme.dart';

class OraculoApp extends ConsumerWidget {
  const OraculoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        // Si no hay nada para "despilar" (por ejemplo, venís de un acceso
        // rápido de la barra inferior) y no estás en Hoy, el botón atrás
        // de Android te lleva a Hoy en vez de cerrar la app de golpe.
        // Si ya estás en Hoy, se comporta normal y sale de la app.
        final isHome =
            GoRouterState.of(context).uri.toString() == AppRoute.mission;
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 2.0,
            ),
          ),
          child: PopScope(
            canPop: isHome || router.canPop(),
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              router.go(AppRoute.mission);
            },
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
