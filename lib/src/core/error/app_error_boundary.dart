import 'package:flutter/material.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({
    required this.message,
    required this.onRecover,
    super.key,
  });

  final String message;
  final VoidCallback onRecover;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.health_and_safety_outlined, size: 56),
                const SizedBox(height: 20),
                Text(
                  'Podemos recuperarnos',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Una parte del contenido no pudo abrirse. Tu progreso local sigue protegido.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Detalle técnico del error',
                  child: SelectableText(
                    message,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRecover,
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('VOLVER A MI MISIÓN'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
