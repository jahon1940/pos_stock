import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    this.label,
  });

  final String? label;

  @override
  Widget build(
    BuildContext context,
  ) =>
      AlertDialog(
        title: const Text('Успешно'),
        content: label == null ? null : const Text('Бренд создан'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('ОК'),
          ),
        ],
      );
}
