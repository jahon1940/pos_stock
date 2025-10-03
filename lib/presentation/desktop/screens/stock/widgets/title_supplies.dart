import 'package:flutter/cupertino.dart';

import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/product_table_title.dart';

class TitleSupplies extends StatelessWidget {
  const TitleSupplies({
    super.key,
    required this.isSupplies,
  });

  final bool isSupplies;

  @override
  Widget build(
    BuildContext context,
  ) =>
      SizedBox(
        height: 50,
        child: TableTitleProducts(
          fillColor: AppColors.stroke,
          columnWidths: isSupplies
              ? const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                }
              : const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
          titles: isSupplies
              ? ['Номер', 'Дата создания', 'Поставщик', 'Продукты', 'Сумма прихода', 'Действия']
              : ['Номер', 'Дата создания', 'Продукты', 'Действия'],
        ),
      );
}
