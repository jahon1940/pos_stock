import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../../../data/dtos/product_dto.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/utils/barcode.dart';
import '../../../../../dialogs/category/bloc/category_bloc.dart';
import '../cubit/product_cubit.dart';

class Product1CDetails extends StatefulWidget {
  const Product1CDetails(
    this.product, {
    super.key,
  });

  final ProductDto? product;

  @override
  State<Product1CDetails> createState() => _Product1CDetailsState();
}

class _Product1CDetailsState extends State<Product1CDetails> {
  ProductDto? get product => widget.product;
  late final TextEditingController categoryController;
  late final TextEditingController titleController;
  late final TextEditingController vendorCodeController;
  List<String> _barcodes = [];

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController();
    titleController = TextEditingController();
    _barcodes.add(BarcodeIdGenerator.generateRandom13DigitNumber());
    context.productBloc.setCrateProductData(barcodes: _barcodes);
    vendorCodeController = TextEditingController();
  }

  @override
  void dispose() {
    categoryController.dispose();
    titleController.dispose();
    vendorCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocListener<ProductCubit, ProductState>(
      listenWhen: (p, c) => !p.isProductDataLoaded && c.isProductDataLoaded,
      listener: (context, state) {
        categoryController.text = state.createProductDataDto.categoryName;
        titleController.text = state.createProductDataDto.name;
        _barcodes = state.createProductDataDto.barcodes;
        vendorCodeController.text = state.createProductDataDto.vendorCode;
      },
      child: CustomBox(
        padding: AppUtils.kPaddingAll12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// title
            Text(
              'Категория: ${product?.category?.name ?? ''}',
              style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
            ),

            ///
            AppUtils.kGap20,
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                final categories = state.categories?.results ?? [];
                return DropdownMenu<int?>(
                  width: 220,
                  hintText: 'Выбор категории',
                  textStyle: const TextStyle(fontSize: 11),
                  controller: categoryController,
                  onSelected: (value) => context.productBloc.setCrateProductData(
                    categoryId: value,
                    categoryName: categoryController.text,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: border(Colors.grey.shade400),
                    hintStyle: const TextStyle(fontSize: 11),
                    isDense: true,
                    constraints: BoxConstraints.tight(const Size.fromHeight(48)),
                  ),
                  dropdownMenuEntries: [
                    const DropdownMenuEntry(
                      value: null,
                      label: 'Все категории',
                    ),
                    ...categories.map((e) => DropdownMenuEntry(value: e.id, label: e.name))
                  ],
                );
              },
            ),

            ///
            AppUtils.kGap20,
            AppTextField(
              prefix: Icon(Icons.title, color: context.primary),
              fieldController: titleController,
              width: double.maxFinite,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              label: 'Название Продукта ...',
              alignLabelWithHint: true,
              style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
              onChange: (value) => context.productBloc.setCrateProductData(name: value),
            ),

            /// barcode
            AppUtils.kGap20,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _barcodes.length,
              separatorBuilder: (_, __) => AppUtils.kMainObjectsGap,
              itemBuilder: (_, index) => _barcodesWidget(
                value: _barcodes.elementAt(index),
                isLast: index == _barcodes.length - 1,
                onGenerate: () {
                  _barcodes[index] = BarcodeIdGenerator.generateRandom13DigitNumber();
                  context.productBloc.setCrateProductData(barcodes: _barcodes);
                  setState(() {});
                },
                onChange: (value) {
                  _barcodes[index] = value;
                  context.productBloc.setCrateProductData(barcodes: _barcodes);
                },
              ),
            ),

            /// vendor code
            AppUtils.kGap20,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    prefix: Icon(
                      Icons.abc,
                      color: context.primary,
                    ),
                    fieldController: vendorCodeController,
                    width: double.maxFinite,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Артикул продукта...',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    onChange: (value) => context.productBloc.setCrateProductData(vendorCode: value),
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

  void _addWidget() => setState(() => _barcodes.add(''));

  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: AppUtils.kBorderRadius8,
        borderSide: BorderSide(color: color),
      );

  Widget _barcodesWidget({
    required String value,
    required VoidCallback onGenerate,
    required bool isLast,
    required Function(String) onChange,
  }) =>
      Row(
        children: [
          /// generate button
          SizedBox(
            height: 50,
            width: context.width * .1,
            child: Material(
              borderRadius: AppUtils.kBorderRadius8,
              color: AppColors.primary500,
              child: InkWell(
                onTap: onGenerate,
                hoverColor: AppColors.primary400,
                highlightColor: AppColors.primary300,
                splashColor: AppColors.primary300,
                borderRadius: AppUtils.kBorderRadius8,
                child: Center(
                  child: Text(
                    'Сгенерировать',
                    maxLines: 2,
                    style: TextStyle(fontSize: 13, color: context.onPrimary),
                  ),
                ),
              ),
            ),
          ),

          /// barcode
          AppUtils.kGap12,
          Expanded(
            flex: 4,
            child: AppTextField(
              prefix: Icon(
                Icons.barcode_reader,
                color: context.primary,
              ),
              fieldController: TextEditingController(text: value),
              width: double.maxFinite,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              label: 'Штрих код продукта...',
              alignLabelWithHint: true,
              style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
              onChange: onChange,
            ),
          ),

          /// add button
          if (isLast) ...[
            AppUtils.kGap12,
            SizedBox(
              height: 50,
              width: 50,
              child: Material(
                borderRadius: AppUtils.kBorderRadius8,
                color: AppColors.primary500,
                child: InkWell(
                  onTap: _addWidget,
                  hoverColor: AppColors.primary400,
                  highlightColor: AppColors.primary300,
                  splashColor: AppColors.primary300,
                  borderRadius: AppUtils.kBorderRadius8,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
}
