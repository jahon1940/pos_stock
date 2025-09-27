import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';

import '../../../../../core/styles/colors.dart';

class TableTitleWidget extends StatelessWidget {
  const TableTitleWidget({
    super.key,
    required this.titles,
  });

  final List<String> titles;

  static const _radius = AppUtils.kTableRadius;

  static const Map<int, TableColumnWidth> columnWidths = {
    0: FlexColumnWidth(),
    1: FlexColumnWidth(4),
    2: FlexColumnWidth(),
  };

  @override
  Widget build(
    BuildContext context,
  ) =>
      Table(
        columnWidths: columnWidths,
        border: TableBorder.all(
          borderRadius: _radius,
          color: AppColors.white,
          width: 2,
        ),
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: AppColors.stroke,
              borderRadius: _radius,
            ),
            children: titles
                .map((e) => SizedBox(
                      height: 40,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 11, left: 10),
                          child: Text(
                            e,
                            style: AppTextStyles.mType14,
                            textAlign: TextAlign.center,
                          )),
                    ))
                .toList(),
          ),
        ],
      );
}
