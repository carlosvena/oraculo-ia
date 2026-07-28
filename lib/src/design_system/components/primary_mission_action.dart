import 'package:flutter/material.dart';

class PrimaryMissionAction extends StatelessWidget {
  const PrimaryMissionAction({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.disabledHint,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(label),
    );
    if (onPressed != null || disabledHint == null || isLoading) return button;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        button,
        const SizedBox(height: 6),
        Text(
          disabledHint!,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ],
    );
  }
}
