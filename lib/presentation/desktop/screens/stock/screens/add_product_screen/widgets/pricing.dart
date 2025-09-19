import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_product_screen/cubit/add_product_cubit.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';

class Pricing extends HookWidget {
  const Pricing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductCubit>();

    return CustomBox(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Ценообразование', style: AppTextStyles.boldType14),
            AppSpace.vertical24,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.monetization_on,
                      color: context.primary,
                    ),
                    fieldController: cubit.incomeController,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    label: 'Приходная цена...',
                    maxLines: 1,
                    alignLabelWithHint: true,
                    textInputType: TextInputType.text,
                    style: AppTextStyles.boldType14
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                AppSpace.horizontal12,
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.monetization_on,
                      color: context.primary,
                    ),
                    fieldController: cubit.sellController,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    label: 'Цена продажи...',
                    maxLines: 1,
                    alignLabelWithHint: true,
                    textInputType: TextInputType.text,
                    style: AppTextStyles.boldType14
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            AppSpace.vertical24,
            // Row(
            //   children: [
            //     Row(
            //       children: [
            //         SizedBox(
            //           height: 18,
            //           width: 18,
            //           child: Checkbox(
            //               value: enableNds,
            //               splashRadius: 10,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(4)),
            //               side: const BorderSide(color: AppColors.stroke),
            //               activeColor: context.primary,
            //               onChanged: (e) {}),
            //         ),
            //         AppSpace.horizontal12,
            //         Text(
            //           'С НДС',
            //           style: AppTextStyles.boldType14
            //               .copyWith(fontWeight: FontWeight.w500),
            //         )
            //       ],
            //     ),
            //     AppSpace.horizontal12,
            //     Opacity(
            //       opacity: enableNds ? 1 : .5,
            //       child: AppTextField(
            //         width: 253,
            //         fieldController: ndsController,
            //         contentPadding: const EdgeInsets.symmetric(
            //             horizontal: 16, vertical: 18),
            //         label: 'НДС (в процентах)...',
            //         readOnly: !enableNds,
            //         maxLines: 1,
            //         alignLabelWithHint: true,
            //         textInputType: TextInputType.text,
            //         style: AppTextStyles.boldType14
            //             .copyWith(fontWeight: FontWeight.w400),
            //       ),
            //     ),
            //     AppSpace.horizontal12,
            //     Expanded(
            //       child: AppTextField(
            //         fieldController: priceController,
            //         contentPadding: const EdgeInsets.symmetric(
            //             horizontal: 16, vertical: 18),
            //         label: 'Цена продажи 1С...',
            //         maxLines: 1,
            //         readOnly: true,
            //         alignLabelWithHint: true,
            //         textInputType: TextInputType.text,
            //         style: AppTextStyles.boldType14
            //             .copyWith(fontWeight: FontWeight.w400),
            //       ),
            //     ),
            //   ],
            // ),
            // AppSpace.vertical24,
            // const Text('Скидка', style: AppTextStyles.boldType14),
            // AppSpace.vertical24,
            // Row(
            //   children: [
            //     SizedBox(
            //       height: 18,
            //       width: 18,
            //       child: Checkbox(
            //           value: enableProduct,
            //           splashRadius: 10,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(4)),
            //           side: const BorderSide(color: AppColors.stroke),
            //           activeColor: context.primary,
            //           onChanged: (e) {}),
            //     ),
            //     AppSpace.horizontal12,
            //     Text(
            //       'Добавить скидку',
            //       style: AppTextStyles.boldType14
            //           .copyWith(fontWeight: FontWeight.w500),
            //     )
            //   ],
            // ),
            // AppSpace.vertical24,
            // Opacity(
            //   opacity: enableProduct ? 1 : .5,
            //   child: Row(
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: AppTextField(
            //           fieldController: discountController,
            //           contentPadding: const EdgeInsets.symmetric(
            //               horizontal: 16, vertical: 18),
            //           label: 'Скидка (в процентах)...',
            //           maxLines: 1,
            //           alignLabelWithHint: true,
            //           textInputType: TextInputType.text,
            //           style: AppTextStyles.boldType14
            //               .copyWith(fontWeight: FontWeight.w400),
            //         ),
            //       ),
            //       AppSpace.horizontal12,
            //       Expanded(
            //         flex: 2,
            //         child: AppTextField(
            //           fieldController: discountFromController,
            //           contentPadding: const EdgeInsets.symmetric(
            //               horizontal: 16, vertical: 18),
            //           label: 'Начало...',
            //           maxLines: 1,
            //           readOnly: true,
            //           prefix: Icon(Icons.calendar_month),
            //           alignLabelWithHint: true,
            //           textInputType: TextInputType.text,
            //           style: AppTextStyles.boldType14
            //               .copyWith(fontWeight: FontWeight.w400),
            //         ),
            //       ),
            //       AppSpace.horizontal24,
            //       Expanded(
            //         flex: 2,
            //         child: AppTextField(
            //           fieldController: discountToController,
            //           contentPadding: const EdgeInsets.symmetric(
            //               horizontal: 16, vertical: 18),
            //           label: 'Конец...',
            //           maxLines: 1,
            //           readOnly: true,
            //           prefix: Icon(Icons.calendar_month),
            //           alignLabelWithHint: true,
            //           textInputType: TextInputType.text,
            //           style: AppTextStyles.boldType14
            //               .copyWith(fontWeight: FontWeight.w400),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
