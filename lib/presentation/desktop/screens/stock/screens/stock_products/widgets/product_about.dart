import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../cubit/product_cubit.dart';

class ProductAbout extends HookWidget {
  const ProductAbout({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final ruDescriptionController = useTextEditingController();
    final uzDescriptionController = useTextEditingController();
    final classifierCodeController = useTextEditingController();
    final classifierNameController = useTextEditingController();
    final packageNameController = useTextEditingController();
    final packageCodeController = useTextEditingController();
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) => CustomBox(
        padding: AppUtils.kPaddingAll12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// title
            Text(
              'О продукте',
              style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
            ),

            /// switches
            AppUtils.kGap20,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      /// actual
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Aктуально',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                          ),
                          Switch(
                            value: state.createProductDataDto.isActual,
                            onChanged: (value) => context.productBloc.setCreateProductData(isActual: value),
                          ),
                        ],
                      ),

                      /// bestseller
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Бестселлер',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                          ),
                          Switch(
                            value: state.createProductDataDto.isBestseller,
                            onChanged: (value) => context.productBloc.setCreateProductData(isBestseller: value),
                          ),
                        ],
                      ),

                      /// discount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Скидка',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                          ),
                          Switch(
                            value: state.createProductDataDto.hasDiscount,
                            onChanged: (value) => context.productBloc.setCreateProductData(hasDiscount: value),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: Column(
                    children: [
                      /// promotion
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Акция',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                          ),
                          Switch(
                            value: state.createProductDataDto.promotion,
                            onChanged: (value) => context.productBloc.setCreateProductData(promotion: value),
                          ),
                        ],
                      ),

                      /// stop list
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cтоп-лист',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                          ),
                          Switch(
                            value: state.createProductDataDto.stopList,
                            onChanged: (value) => context.productBloc.setCreateProductData(stopList: value),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// classifier
            AppUtils.kGap12,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.monetization_on,
                      color: context.primary,
                    ),
                    fieldController: classifierNameController,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Наименование классификатора...',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    onChange: (value) => context.productBloc.setCreateProductData(price: int.tryParse(value)),
                  ),
                ),
                AppUtils.kGap12,
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.monetization_on,
                      color: context.primary,
                    ),
                    fieldController: classifierCodeController,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Код классификатора ...',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    onChange: (value) => context.productBloc.setCreateProductData(purchasePrice: int.tryParse(value)),
                  ),
                ),
              ],
            ),

            /// package
            AppUtils.kGap12,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.monetization_on,
                      color: context.primary,
                    ),
                    fieldController: packageNameController,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Единица измерения (название) ...',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    onChange: (value) => context.productBloc.setCreateProductData(purchasePrice: int.tryParse(value)),
                  ),
                ),
                AppUtils.kGap12,
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.monetization_on,
                      color: context.primary,
                    ),
                    fieldController: packageCodeController,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Код упаковки...',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    onChange: (value) => context.productBloc.setCreateProductData(price: int.tryParse(value)),
                  ),
                ),
              ],
            ),

            ///
            AppUtils.kGap12,
            AppTextField(
              fieldController: ruDescriptionController,
              label: 'Описание Продукта на Русском...',
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              maxLines: 4,
              style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
            ),

            ///
            AppUtils.kGap12,
            AppTextField(
              fieldController: uzDescriptionController,
              label: 'Описание Продукта на Узбекском...',
              alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              maxLines: 4,
              style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
