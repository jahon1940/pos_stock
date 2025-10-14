import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/custom_square_icon_btn.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/measure/measure_dto.dart';

class MeasureItemWidget extends StatelessWidget {
  const MeasureItemWidget({
    super.key,
    required this.country,
  });

  final MeasureDto country;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: {
          0: const FlexColumnWidth(2),
          1: const FlexColumnWidth(6),
          2: const FlexColumnWidth(2),
        },
        onTap: () async {},
        children: [
          _item(
            child: Text('${country.id}'),
          ),
          _item(
            child: Text(country.name ?? ''),
          ),
          _item(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomSquareIconBtn(
                  backgrounColor: AppColors.primary500,
                  Icons.edit,
                ),
                CustomSquareIconBtn(
                  Icons.delete,
                  backgrounColor: AppColors.error500,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _item({
    required Widget child,
  }) =>
      Padding(
        padding: AppUtils.kPaddingAll10,
        child: child,
      );
}
