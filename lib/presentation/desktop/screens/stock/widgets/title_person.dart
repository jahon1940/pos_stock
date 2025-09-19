import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/product_table_title.dart';

class TitlePerson extends StatelessWidget {
  const TitlePerson({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TableTitleProducts(
        fillColor: AppColors.stroke,
        columnWidths: const {
          0: FlexColumnWidth(6),
          1: FlexColumnWidth(4),
          2: FlexColumnWidth(4),
          3: FlexColumnWidth(2),
        },
        titles: [
          context.tr("name"),
          context.tr("phone_number"),
          context.tr("tin_pinfl"),
          "Действия",
        ],
      ),
    );
  }
}
