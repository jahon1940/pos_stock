import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

class OperationResultDialog extends StatelessWidget {
  const OperationResultDialog({
    super.key,
    this.label,
    this.isError = false,
  });

  final String? label;
  final bool isError;

  @override
  Widget build(
    BuildContext context,
  ) =>
      AlertDialog(
        title: isError
            ? const Text(
                'Ошибка',
                style: TextStyle(color: Colors.red),
              )
            : const Text('Успешно'),
        content: label == null ? null : Text(label!),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('ОК'),
          ),
        ],
      );
}
