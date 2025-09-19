import 'package:flutter/material.dart';

import '../styles/colors.dart';

class TableProductItem extends StatelessWidget {
  const TableProductItem({
    super.key,
    this.columnWidths,
    required this.children,
    required this.onTap,
    this.color,
    this.tableBorder,
  });

  final Map<int, TableColumnWidth>? columnWidths;
  final List<Widget> children;
  final VoidCallback onTap;
  final Color? color;
  final double? tableBorder;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      hoverColor: AppColors.primary100.withOpacity(0.4),
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Table(
        border: TableBorder.all(
            borderRadius: BorderRadius.circular(8),
            color: theme.dividerColor,
            width: tableBorder ?? 2),
        columnWidths: columnWidths,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            children: children,
          )
        ],
      ),
    );
  }
}
