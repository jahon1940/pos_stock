import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../constants/app_utils.dart';
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

  static const _radius = AppUtils.kTableRadius;

  @override
  Widget build(
    BuildContext context,
  ) =>
      InkWell(
        hoverColor: AppColors.primary100.opcty(0.4),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Table(
          border: TableBorder.all(
            borderRadius: _radius,
            color: context.theme.dividerColor,
            width: tableBorder ?? 2,
          ),
          columnWidths: columnWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: color,
                borderRadius: _radius,
              ),
              children: children,
            )
          ],
        ),
      );
}
