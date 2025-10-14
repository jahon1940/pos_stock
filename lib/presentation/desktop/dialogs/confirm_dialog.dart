import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.label,
    required this.onConfirm,
  });

  final String label;
  final VoidCallback onConfirm;

  @override
  Widget build(
    BuildContext context,
  ) =>
      AlertDialog(
        content: Text(label),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Нет'),
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text('Да'),
          ),
        ],
      );
}
