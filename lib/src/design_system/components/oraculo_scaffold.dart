import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';

class OraculoScaffold extends StatelessWidget {
  const OraculoScaffold({required this.body, this.bottomAction, super.key});

  final Widget body;
  final Widget? bottomAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(child: body),
                  if (bottomAction != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.lg),
                    bottomAction!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
