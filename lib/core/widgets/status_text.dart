import 'package:flutter/material.dart';

import '../enums/statuses.dart';

class StatusText extends StatelessWidget {
  final String text;
  final Statuses status;

  const StatusText({
    Key? key,
    required this.status, required this.text,
  }) : super(key: key);

  Color _getColor(Statuses status) {
    switch (status) {
      case Statuses.success:
        return Colors.green;
      case Statuses.error:
        return Colors.red;
      case Statuses.warning:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(
            fontWeight: FontWeight.bold,
            color: _getColor(status),
          ),
    );
  }
}
