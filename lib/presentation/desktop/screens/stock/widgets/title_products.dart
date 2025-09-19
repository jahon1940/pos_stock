import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/product_table_title.dart';

class TitleProducts extends StatelessWidget {
  const TitleProducts({
    super.key,
    this.showActions = true,
    this.showSupply = false,
  });

  final bool showActions;
  final bool showSupply;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TableTitleProducts(
        fillColor: AppColors.stroke,
        columnWidths: {
          0: FlexColumnWidth(6),
          if (showSupply) 1: FlexColumnWidth(4),
          2: FlexColumnWidth(3),
          3: FlexColumnWidth(3),
          4: FlexColumnWidth(3),
          if (showActions) 5: FlexColumnWidth(3),
          if (showActions) 6: FlexColumnWidth(3),
        },
        titles: [
          '${context.tr("name")}/${context.tr("article")}',
          "Категория",
          if (showSupply) 'Поставщик',
          context.tr("count_short"),
          context.tr("priceFrom"),
          context.tr("priceTo"),
          if (showActions) "Действия",
        ],
      ),
    );
  }
}
