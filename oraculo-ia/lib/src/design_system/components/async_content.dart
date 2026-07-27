import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncContent<T> extends StatelessWidget {
  const AsyncContent({
    required this.value,
    required this.data,
    required this.errorMessage,
    required this.retryLabel,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T value) data;
  final String errorMessage;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stackTrace) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton(onPressed: onRetry, child: Text(retryLabel)),
              ],
            ),
          ),
    );
  }
}
