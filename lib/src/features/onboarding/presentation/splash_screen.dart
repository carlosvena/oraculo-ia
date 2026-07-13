import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oraculo_ia/l10n/app_localizations.dart';
import 'package:oraculo_ia/src/design_system/foundations/app_spacing.dart';
import 'package:oraculo_ia/src/features/onboarding/presentation/splash_view_model.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({required this.onResolved, super.key});

  final ValueChanged<bool> onResolved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(splashViewModelProvider, (previous, next) {
      next.whenData((completed) {
        if (context.mounted) {
          onResolved(completed);
        }
      });
    });

    return const Scaffold(body: Center(child: _BrandMark()));
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      label: l10n.appName,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.auto_awesome_rounded,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.appName,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(letterSpacing: 3),
          ),
        ],
      ),
    );
  }
}
