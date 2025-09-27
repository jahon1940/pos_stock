import 'package:flutter/cupertino.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/product_table_title.dart';

class StocksTitle extends StatelessWidget {
  const StocksTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TableTitleProducts(
        fillColor: AppColors.stroke,
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(4),
          2: FlexColumnWidth(1),
        },
        titles: ['Номер', 'Название', 'Действия'],
      ),
    );
  }
}
