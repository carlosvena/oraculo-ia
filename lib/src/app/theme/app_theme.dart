import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _seed = Color(0xFF8B7CFF); // violeta, color de marca
  static const Color _secondarySeed = Color(0xFFFF8A65); // coral cálido
  static const Color _tertiarySeed = Color(0xFF4FD1C5); // verde azulado
  static const Color _background = Color(0xFF0B0B0F);
  static const Color _surface = Color(0xFF17171D);

  static ThemeData get dark {
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      surface: _surface,
    );
    // El violeta solo (fromSeed) genera secundario/terciario en la misma
    // familia de tono, por eso todo se ve "de un solo color". Le damos
    // variedad real usando semillas de tono distinto para cada rol.
    final secondaryScheme = ColorScheme.fromSeed(
      seedColor: _secondarySeed,
      brightness: Brightness.dark,
    );
    final tertiaryScheme = ColorScheme.fromSeed(
      seedColor: _tertiarySeed,
      brightness: Brightness.dark,
    );
    final scheme = base.copyWith(
      secondary: secondaryScheme.primary,
      onSecondary: secondaryScheme.onPrimary,
      secondaryContainer: secondaryScheme.primaryContainer,
      onSecondaryContainer: secondaryScheme.onPrimaryContainer,
      tertiary: tertiaryScheme.primary,
      onTertiary: tertiaryScheme.onPrimary,
      tertiaryContainer: tertiaryScheme.primaryContainer,
      onTertiaryContainer: tertiaryScheme.onPrimaryContainer,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: _background,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w700, height: 1.1),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700, height: 1.2),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(height: 1.5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
