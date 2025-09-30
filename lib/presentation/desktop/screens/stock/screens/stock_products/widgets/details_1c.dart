import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../../../data/dtos/product_dto.dart';
import '../../../../../dialogs/category/bloc/category_bloc.dart';
import '../../../../search/cubit/search_bloc.dart';
import '../cubit/add_product_cubit.dart';

class Details1C extends HookWidget {
  const Details1C(
    this.product, {
    super.key,
    this.isDialog,
  });

  final ProductDto? product;
  final bool? isDialog;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddProductCubit>();
    final categoryController = useTextEditingController();
    return CustomBox(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Категория: ${product?.category?.name ?? ""}"),
            AppSpace.vertical24,
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: DropdownMenu<int?>(
                      width: 220,
                      hintText: 'Выбор категории',
                      textStyle: const TextStyle(fontSize: 11),
                      controller: categoryController,
                      onSelected: (value) {
                        isDialog == true
                            ? context.read<AddProductCubit>().selectCategory(value)
                            : context.searchBloc.add(SelectCategory(id: value));
                      },
                      inputDecorationTheme: InputDecorationTheme(
                        hintStyle: const TextStyle(fontSize: 11),
                        isDense: true,
                        constraints: BoxConstraints.tight(const Size.fromHeight(35)),
                      ),
                      dropdownMenuEntries: [
                        const DropdownMenuEntry(
                          value: null,
                          label: 'Все категории',
                        ),
                        ...state.categories?.results
                                .map(
                                  (e) => DropdownMenuEntry(
                                    value: e.id,
                                    label: e.name ?? '',
                                  ),
                                )
                                .toList() ??
                            []
                      ],
                    ),
                  ),
                );
              },
            ),
            AppSpace.vertical24,
            AppTextField(
              prefix: Icon(
                Icons.title,
                color: context.primary,
              ),
              fieldController: cubit.titleController,
              width: double.maxFinite,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              label: 'Название Продукта ...',
              alignLabelWithHint: true,
              style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
            ),
            AppSpace.vertical24,
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => cubit.generateBarcode(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                    height: 50,
                    width: context.width * .1,
                    child: Center(
                      child: Text(
                        "Сгенерить",
                        maxLines: 2,
                        style: TextStyle(fontSize: 13, color: context.onPrimary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    prefix: Icon(
                      Icons.barcode_reader,
                      color: context.primary,
                    ),
                    fieldController: cubit.barcodeController,
                    width: double.maxFinite,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Штрих код продукта...',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),

                AppSpace.horizontal12,
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.abc,
                      color: context.primary,
                    ),
                    fieldController: cubit.codeController,
                    width: double.maxFinite,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Артикул продукта...',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                // AppSpace.horizontal12,
                // Expanded(
                //   flex: 1,
                //   child: AppTextField(
                //     prefix: Icon(
                //       Icons.check_box_outline_blank,
                //       color: context.primary,
                //     ),
                //     fieldController: cubit.quantityController,
                //     width: double.maxFinite,
                //     contentPadding: const EdgeInsets.symmetric(
                //         horizontal: 16, vertical: 18),
                //     label: 'Количество...',
                //     alignLabelWithHint: true,
                //     maxLines: 1,
                //     textInputType: TextInputType.text,
                //     style: AppTextStyles.boldType14
                //         .copyWith(fontWeight: FontWeight.w400),
                //   ),
                // ),
                // AppSpace.horizontal12,
                // SizedBox(
                //   width: 120,
                //   child: CustomBox(
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 5, right: 5),
                //       child: DropdownButton<String>(
                //         borderRadius: BorderRadius.circular(10),
                //         isExpanded: true,
                //         underline: const SizedBox(),
                //         value: "KG",
                //         hint: Padding(
                //           padding: const EdgeInsets.only(left: 10),
                //           child: Text(
                //             "viewModel.product.measure" ?? '',
                //             style: AppTextStyles.boldType14
                //                 .copyWith(fontWeight: FontWeight.w400),
                //           ),
                //         ),
                //         alignment: Alignment.centerLeft,
                //         items: <String>[
                //           'KG',
                //           'GR',
                //           'LITR',
                //           'PIECE',
                //         ].map((String value) {
                //           return DropdownMenuItem<String>(
                //             value: value,
                //             child: Padding(
                //               padding: const EdgeInsets.only(left: 10),
                //               child: Text(
                //                   value == 'KG'
                //                       ? "Кило"
                //                       : value == 'GR'
                //                           ? "Грамм"
                //                           : value == 'LITR'
                //                               ? "Литр"
                //                               : value == 'PIECE'
                //                                   ? "Штука"
                //                                   : "",
                //                   style: AppTextStyles.boldType14
                //                       .copyWith(fontWeight: FontWeight.w500)),
                //             ),
                //           );
                //         }).toList(),
                //         onChanged: (value) {
                //           // viewModel.onChangeMeasure(value);
                //         },
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
