import 'package:flutter/material.dart';

class PrimaryMissionAction extends StatelessWidget {
  const PrimaryMissionAction({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : Text(label),
    );
  }
}
