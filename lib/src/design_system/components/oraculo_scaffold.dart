import 'package:flutter/material.dart';
import 'package:oraculo_ia/src/design_system/components/main_bottom_nav.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';

class OraculoScaffold extends StatelessWidget {
  const OraculoScaffold({
    required this.body,
    this.bottomAction,
    this.bottomNavIndex,
    super.key,
  });

  final Widget body;
  final Widget? bottomAction;

  /// Si se pasa (0 a 4), muestra la barra de accesos rápidos
  /// (Hoy / Mi curso / Practicar / Explorar / Mi progreso) resaltando
  /// ese índice. Si es null, no se muestra (comportamiento anterior).
  final int? bottomNavIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          bottomNavIndex == null
              ? null
              : MainBottomNav(currentIndex: bottomNavIndex!),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.sizeOf(context).width < 360
                    ? AppSpacing.md
                    : AppSpacing.lg,
                AppSpacing.xl,
                MediaQuery.sizeOf(context).width < 360
                    ? AppSpacing.md
                    : AppSpacing.lg,
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
