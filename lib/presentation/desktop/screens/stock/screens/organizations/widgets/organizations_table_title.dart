import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';

import '../../../../../../../core/styles/colors.dart';

class OrganizationsTableTitle extends StatelessWidget {
  const OrganizationsTableTitle({
    super.key,
    required this.columnWidths,
    required this.titles,
  });

  final Map<int, TableColumnWidth> columnWidths;
  final List<String> titles;

  static const _radius = AppUtils.kTableRadius;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Table(
        border: TableBorder.all(
          borderRadius: _radius,
          color: AppColors.white,
          width: 2,
        ),
        columnWidths: columnWidths,
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.stroke,
              borderRadius: _radius,
            ),
            children: titles
                .map((e) => SizedBox(
                      height: 40,
                      child: Padding(
                          padding: EdgeInsets.only(top: 11, left: 10),
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
