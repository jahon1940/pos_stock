import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';

import '../styles/colors.dart';

class TableTitleProducts extends StatelessWidget {
  const TableTitleProducts({
    super.key,
    this.columnWidths,
    this.fillColor,
    required this.titles,
  });

  final Map<int, TableColumnWidth>? columnWidths;
  final List<String> titles;
  final Color? fillColor;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Table(
          border: TableBorder.all(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.white,
            width: 2,
          ),
          columnWidths: columnWidths,
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(10),
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
        ),
      );
}
