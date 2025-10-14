import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../data/dtos/product_param_dto.dart';

class CreateBrandDialog extends StatelessWidget {
  const CreateBrandDialog({
    super.key,
    this.categoryDto,
  });

  final ProductParamDto? categoryDto;

  @override
  Widget build(
    BuildContext context,
  ) {
    final nameController = TextEditingController();
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadius12),
      contentPadding: AppUtils.kPaddingAll24,
      content: SizedBox(
        width: context.width * .3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// title
                const Text(
                  'Создания бренд',
                  style: AppTextStyles.boldType18,
                ),

                /// close button
                SizedBox(
                  height: 48,
                  width: 48,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.error100,
                    child: InkWell(
                      hoverColor: AppColors.error200,
                      highlightColor: AppColors.error300,
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.pop(),
                      child: const Icon(Icons.close, color: AppColors.error600),
                    ),
                  ),
                )
              ],
            ),

            /// content
            AppUtils.kGap24,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///
                AppTextField(
                  label: 'Название',
                  enabledBorderWith: 1,
                  enabledBorderColor: AppColors.stroke,
                  focusedBorderColor: AppColors.stroke,
                  focusedBorderWith: 1,
                  fieldController: nameController,
                ),

                /// button
                AppUtils.kGap24,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary800,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    /// todo implement create event
                    context.pop(context);
                  },
                  child: const Text(
                    'Создать бренд',
                    style: AppTextStyles.boldType16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
