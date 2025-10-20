import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/category/widgets/create_category_dialog.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/category/category_dto.dart';
import '../../../../../dialogs/category/bloc/category_bloc.dart';
import '../../../../../dialogs/confirm_dialog.dart';
import '../../../../../dialogs/operation_result_dialog.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({
    super.key,
    required this.category,
  });

  final CategoryDto category;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: {
          0: const FlexColumnWidth(2),
          1: const FlexColumnWidth(5),
          2: const FlexColumnWidth(),
          3: const FlexColumnWidth(2),
        },
        onTap: () async {},
        children: [
          _item(
            child: Text('${category.id}'),
          ),
          _item(
            child: Text(category.name),
          ),
          _item(
            child: category.image.isNotEmpty
                ? Center(
              child: ClipRRect(
                borderRadius: AppUtils.kBorderRadius8,
                child: Container(
                  color: Colors.red,
                  height: 40,
                  width: 40,
                  child: Image.network(
                    category.imageLink,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
                : const Center(),
          ),
          _item(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // for testing
                // Container(
                //   height: 40,
                //   width: 40,
                //   child: category.image.isEmpty ? null : Image.network(category.imageLink),
                // ),
                CustomSquareIconBtn(
                  Icons.edit,
                  backgrounColor: AppColors.primary500,
                  onTap: () => showDialog<bool?>(
                    context: context,
                    builder: (_) => CreateCategoryDialog(category: category),
                  ).then((isSuccess) async {
                    if (isSuccess.isNotNull) {
                      await Future.delayed(Durations.medium1);
                      await showDialog(
                        context: context,
                        builder: (context) => OperationResultDialog(
                          label: isSuccess! ? 'Котегория обновлен' : null,
                          isError: !isSuccess,
                        ),
                      );
                    }
                  }),
                ),
                CustomSquareIconBtn(
                  Icons.delete,
                  backgrounColor: AppColors.error500,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      label: 'Вы хотите удалить?',
                      onConfirm: () => context
                        ..pop()
                        ..categoryBloc.add(DeleteCategoryIdEvent(category.cid)),
                    ),
                  ),
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
