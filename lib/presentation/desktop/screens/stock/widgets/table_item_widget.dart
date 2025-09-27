import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';

import 'table_title_widget.dart';

class TableItemWidget extends StatelessWidget {
  const TableItemWidget({
    super.key,
    required this.leadingLabel,
    required this.bodyLabel,
    required this.onTap,
  });

  final String leadingLabel;
  final String bodyLabel;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: TableTitleWidget.columnWidths,
        onTap: onTap,
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: AppUtils.kPaddingAll12,
              child: Text(leadingLabel),
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: AppUtils.kPaddingAll12,
              child: Text(bodyLabel),
            ),
          ),
          const SizedBox(),
        ],
      );
}
