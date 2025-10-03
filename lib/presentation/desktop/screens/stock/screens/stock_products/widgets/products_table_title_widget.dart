import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/product_table_title.dart';

class ProductsTableTitleWidget extends StatelessWidget {
  const ProductsTableTitleWidget({
    super.key,
  });

  static const columnWidths = {
    0: FlexColumnWidth(6),
    1: FlexColumnWidth(4),
    2: FlexColumnWidth(3),
    3: FlexColumnWidth(3),
    4: FlexColumnWidth(3),
    5: FlexColumnWidth(3),
    6: FlexColumnWidth(3),
  };

  @override
  Widget build(
    BuildContext context,
  ) =>
      SizedBox(
        height: 50,
        child: TableTitleProducts(
          fillColor: AppColors.stroke,
          columnWidths: columnWidths,
          titles: [
            '${context.tr("name")}/${context.tr("article")}',
            "Категория",
            'Поставщик',
            context.tr("count_short"),
            context.tr("priceFrom"),
            context.tr("priceTo"),
            "Действия",
          ],
        ),
      );
}
