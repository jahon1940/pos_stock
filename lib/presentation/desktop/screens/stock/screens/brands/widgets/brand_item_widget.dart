import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/brand/brand_dto.dart';
import '../../../../../dialogs/operation_result_dialog.dart';
import 'create_brand_dialog.dart';

class BrandItemWidget extends StatelessWidget {
  const BrandItemWidget({
    super.key,
    required this.brand,
  });

  final BrandDto brand;

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
            child: Text('${brand.id}'),
          ),
          _item(
            child: Text(brand.name ?? ''),
          ),
          _item(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomSquareIconBtn(
                  backgrounColor: AppColors.primary500,
                  Icons.edit,
                  onTap: () => showDialog<bool?>(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.brandBloc,
                      child: CreateBrandDialog(brand: brand),
                    ),
                  ).then((isSuccess) async {
                    if (isSuccess.isNotNull) {
                      await Future.delayed(Durations.medium1);
                      await showDialog(
                        context: context,
                        builder: (context) => OperationResultDialog(
                          label: isSuccess! ? 'Бренд обновлен' : null,
                          isError: !isSuccess,
                        ),
                      );
                    }
                  }),
                ),
                const CustomSquareIconBtn(
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
