import 'package:flutter/material.dart';

/// Reemplaza la pantalla roja/gris de error por defecto de Flutter cuando
/// algo revienta al construir un widget. No depende de Riverpod ni de
/// providers propios a propósito: si la app ya está rota, necesitamos el
/// widget de emergencia más simple posible para que sí o sí se muestre.
class FriendlyCrashFallback extends StatelessWidget {
  const FriendlyCrashFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF17171D),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.build_circle_outlined, size: 48, color: Colors.white70),
                SizedBox(height: 16),
                Text(
                  'Algo no cargó bien acá',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Tu progreso local no se pierde. Volvé atrás o abrí la app '
                  'de nuevo para seguir.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
