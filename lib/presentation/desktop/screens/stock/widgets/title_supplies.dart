import 'package:flutter/cupertino.dart';

import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/product_table_title.dart';

class TitleSupplies extends StatelessWidget {
  const TitleSupplies({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      const SizedBox(
        height: 50,
        child: TableTitleProducts(
          fillColor: AppColors.stroke,
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
          },
          titles: ['Номер', 'Дата создания', 'Продукты', 'Действия'],
        ),
      );
}
