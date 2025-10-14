import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';

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
                CustomSquareIconBtn(
                  Icons.close,
                  size: 48,
                  darkenColors: true,
                  backgrounColor: AppColors.error100,
                  iconColor: AppColors.error600,
                  onTap: () => context.pop(),
                ),
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
