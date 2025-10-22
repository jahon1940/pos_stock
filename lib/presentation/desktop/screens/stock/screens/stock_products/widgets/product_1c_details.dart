import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/data/dtos/brand/brand_dto.dart';
import 'package:hoomo_pos/data/dtos/category/category_dto.dart';
import 'package:hoomo_pos/data/dtos/country/country_dto.dart';

import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/utils/barcode.dart';
import '../cubit/product_cubit.dart';
import 'select_brand_dialog.dart';
import 'select_category_dialog.dart';
import 'select_country_dialog.dart';

class Product1CDetails extends StatefulWidget {
  const Product1CDetails({
    super.key,
  });

  @override
  State<Product1CDetails> createState() => _Product1CDetailsState();
}

class _Product1CDetailsState extends State<Product1CDetails> {
  String _selectedCategoryName = '';
  String _selectedBrandName = '';
  String _selectedCountryName = '';
  late final TextEditingController _ruNameController;
  late final TextEditingController _uzNameController;
  late final TextEditingController _vendorCodeController;
  late final TextEditingController _quantityController;
  late final TextEditingController _minQuantityController;
  late final TextEditingController _maxQuantityController;
  List<String> _barcodes = [];

  @override
  void initState() {
    super.initState();
    _ruNameController = TextEditingController();
    _uzNameController = TextEditingController();
    _barcodes.add(BarcodeIdGenerator.generateRandom13DigitNumber());
    context.productBloc.setCreateProductData(barcodes: _barcodes);
    _vendorCodeController = TextEditingController();
    _quantityController = TextEditingController();
    _minQuantityController = TextEditingController();
    _maxQuantityController = TextEditingController();
  }

  @override
  void dispose() {
    _ruNameController.dispose();
    _uzNameController.dispose();
    _vendorCodeController.dispose();
    _quantityController.dispose();
    _minQuantityController.dispose();
    _maxQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocConsumer<ProductCubit, ProductState>(
        listenWhen: (p, c) =>
            (!p.isProductDataLoaded && c.isProductDataLoaded) ||
            (c.mirelProductTemplate.isNotNull && p.mirelProductTemplate?.id != c.mirelProductTemplate!.id),
        listener: (context, state) {
          if (state.mirelProductTemplate.isNotNull) {
            final template = state.mirelProductTemplate!;
            _ruNameController.text = template.title ?? _ruNameController.text;
            _uzNameController.text = template.title ?? _uzNameController.text;
            _vendorCodeController.text = template.vendorCode ?? _vendorCodeController.text;
            _quantityController.text = template.quantity?.toString() ?? _quantityController.text;
            _minQuantityController.text = template.minBoxQuantity?.toString() ?? _minQuantityController.text;
            _maxQuantityController.text = template.maxQuantity?.toString() ?? _maxQuantityController.text;
            _barcodes = (template.barcode ?? []).isNotEmpty ? List.from(template.barcode!) : _barcodes;
            return;
          }
          _selectedCategoryName = state.createProductDataDto.categoryName;
          _selectedBrandName = state.createProductDataDto.brandName;
          _selectedCountryName = state.createProductDataDto.countryName;
          _ruNameController.text = state.createProductDataDto.nameRu;
          _uzNameController.text = state.createProductDataDto.nameRu;
          _barcodes = List.from(state.createProductDataDto.barcodes);
          _vendorCodeController.text = state.createProductDataDto.vendorCode;
          _quantityController.text = state.createProductDataDto.quantity.toString();
          _minQuantityController.text = state.createProductDataDto.minBoxQuantity.toString();
          _maxQuantityController.text = state.createProductDataDto.maxQuantity.toString();
        },
        builder: (context, state) => CustomBox(
          padding: AppUtils.kPaddingAll12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// category

              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Категория:',
                          style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                        ),
                      ),

                      ///
                      AppUtils.kGap20,
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: 220,
                          height: 50,
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: AppUtils.kBorderRadius8,
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            child: InkWell(
                              borderRadius: AppUtils.kBorderRadius8,
                              hoverColor: Colors.grey.shade100,
                              child: Row(
                                children: [
                                  AppUtils.kGap12,
                                  Text(
                                    _selectedCategoryName.isEmpty ? 'Все категории' : _selectedCategoryName,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down, size: 18),
                                  AppUtils.kGap12,
                                ],
                              ),
                              onTap: () async {
                                final item = await showDialog<CategoryDto?>(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.categoryBloc,
                                    child: const SelectCategoryDialog(),
                                  ),
                                );
                                if (item.isNotNull) {
                                  _selectedCategoryName = item!.name;
                                  context.productBloc.setCreateProductData(
                                    categoryCid: item.cid,
                                    categoryName: item.name,
                                  );
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedCategoryName.isEmpty && (state.mirelProductTemplate?.category?.name ?? '').isNotEmpty)
                    Row(
                      children: [
                        const Expanded(child: Center()),
                        AppUtils.kGap20,
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              const Text('  Категория в справочнике:  ', style: AppTextStyles.mType12),
                              SelectableText(
                                state.mirelProductTemplate!.category!.name!,
                                style: AppTextStyles.mType12.copyWith(color: AppColors.primary400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              /// brand
              AppUtils.kGap12,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Бренд:',
                          style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                        ),
                      ),

                      ///
                      AppUtils.kGap20,
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: 220,
                          height: 50,
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: AppUtils.kBorderRadius8,
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            child: InkWell(
                              borderRadius: AppUtils.kBorderRadius8,
                              hoverColor: Colors.grey.shade100,
                              child: Row(
                                children: [
                                  AppUtils.kGap12,
                                  Text(
                                    _selectedBrandName.isEmpty ? 'Все бренды' : _selectedBrandName,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down, size: 18),
                                  AppUtils.kGap12,
                                ],
                              ),
                              onTap: () async {
                                final item = await showDialog<BrandDto?>(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.brandBloc,
                                    child: const SelectBrandDialog(),
                                  ),
                                );
                                if (item.isNotNull) {
                                  _selectedBrandName = item!.name;
                                  context.productBloc.setCreateProductData(
                                    brandCid: item.cid,
                                    brandName: item.name,
                                  );
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedBrandName.isEmpty && (state.mirelProductTemplate?.brand?.name ?? '').isNotEmpty)
                    Row(
                      children: [
                        const Expanded(child: Center()),
                        AppUtils.kGap20,
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              const Text('  Бренд в справочнике:  ', style: AppTextStyles.mType12),
                              SelectableText(
                                state.mirelProductTemplate!.brand!.name!,
                                style: AppTextStyles.mType12.copyWith(color: AppColors.primary400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              /// country
              AppUtils.kGap12,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Страна производства:',
                          style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                        ),
                      ),

                      ///
                      AppUtils.kGap20,
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: 220,
                          height: 50,
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: AppUtils.kBorderRadius8,
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            child: InkWell(
                              borderRadius: AppUtils.kBorderRadius8,
                              hoverColor: Colors.grey.shade100,
                              child: Row(
                                children: [
                                  AppUtils.kGap12,
                                  Text(
                                    _selectedCountryName.isEmpty ? 'Все cтрана' : _selectedCountryName,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.arrow_drop_down, size: 18),
                                  AppUtils.kGap12,
                                ],
                              ),
                              onTap: () async {
                                final item = await showDialog<CountryDto?>(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.countryBloc,
                                    child: const SelectCountryDialog(),
                                  ),
                                );
                                if (item.isNotNull) {
                                  _selectedCountryName = item!.name ?? ' - ';
                                  context.productBloc.setCreateProductData(
                                    countryCid: item.cid,
                                    countryName: item.name,
                                  );
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedCountryName.isEmpty && (state.mirelProductTemplate?.madeIn?.name ?? '').isNotEmpty)
                    Row(
                      children: [
                        const Expanded(child: Center()),
                        AppUtils.kGap20,
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              const Text('  Страна производства в справочнике:  ', style: AppTextStyles.mType12),
                              SelectableText(
                                state.mirelProductTemplate!.madeIn!.name!,
                                style: AppTextStyles.mType12.copyWith(color: AppColors.primary400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              ///
              AppUtils.kGap20,
              AppTextField(
                prefix: Icon(Icons.title, color: context.primary),
                fieldController: _ruNameController,
                width: double.maxFinite,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                label: 'Название Продукта на Русском...',
                alignLabelWithHint: true,
                style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                onChange: (value) => context.productBloc.setCreateProductData(nameRu: value),
              ),

              ///
              AppUtils.kGap12,
              AppTextField(
                prefix: Icon(Icons.title, color: context.primary),
                fieldController: _uzNameController,
                width: double.maxFinite,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                label: 'Название Продукта на Узбекском...',
                alignLabelWithHint: true,
                style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                onChange: (value) => context.productBloc.setCreateProductData(nameUz: value),
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
                    context.productBloc.setCreateProductData(barcodes: _barcodes);
                    setState(() {});
                  },
                  onChange: (value) {
                    _barcodes[index] = value;
                    context.productBloc.setCreateProductData(barcodes: _barcodes);
                  },
                  onRemoveWidget: () {
                    _barcodes.removeAt(index);
                    context.productBloc.setCreateProductData(barcodes: _barcodes);
                    setState(() {});
                  },
                ),
              ),

              /// vendor code
              AppUtils.kGap12,
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      prefix: Icon(
                        Icons.abc,
                        color: context.primary,
                      ),
                      fieldController: _vendorCodeController,
                      width: double.maxFinite,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      label: 'Артикул продукта',
                      alignLabelWithHint: true,
                      style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                      onChange: (value) => context.productBloc.setCreateProductData(vendorCode: value),
                    ),
                  ),
                  AppUtils.kMainObjectsGap,
                  Expanded(
                    child: AppTextField(
                      prefix: Icon(
                        Icons.onetwothree,
                        color: context.primary,
                      ),
                      fieldController: _quantityController,
                      width: double.maxFinite,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      label: 'Количество в коробке',
                      alignLabelWithHint: true,
                      style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                      onChange: (value) => context.productBloc.setCreateProductData(quantity: int.tryParse(value)),
                    ),
                  ),
                  // AppUtils.kMainObjectsGap,
                  // SizedBox(
                  //   width: 120,
                  //   child: CustomBox(
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 5, right: 5),
                  //       child: DropdownButton<String>(
                  //         borderRadius: BorderRadius.circular(10),
                  //         isExpanded: true,
                  //         underline: const SizedBox(),
                  //         value: 'KG',
                  //         hint: Padding(
                  //           padding: const EdgeInsets.only(left: 10),
                  //           child: Text(
                  //             'viewModel.product.measure' ?? '',
                  //             style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
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
                  //                       ? 'Кило'
                  //                       : value == 'GR'
                  //                           ? 'Грамм'
                  //                           : value == 'LITR'
                  //                               ? 'Литр'
                  //                               : value == 'PIECE'
                  //                                   ? 'Штука'
                  //                                   : '',
                  //                   style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500)),
                  //             ),
                  //           );
                  //         }).toList(),
                  //         onChanged: (value) {},
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              AppUtils.kGap12,
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      prefix: Icon(
                        Icons.abc,
                        color: context.primary,
                      ),
                      fieldController: _minQuantityController,
                      width: double.maxFinite,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      label: 'Mинимальное количество',
                      alignLabelWithHint: true,
                      style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  AppUtils.kMainObjectsGap,
                  Expanded(
                    child: AppTextField(
                      prefix: Icon(
                        Icons.onetwothree,
                        color: context.primary,
                      ),
                      fieldController: _maxQuantityController,
                      width: double.maxFinite,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      label: 'Mаксимальное количество',
                      alignLabelWithHint: true,
                      style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  // AppUtils.kMainObjectsGap,
                  // SizedBox(
                  //   width: 120,
                  //   child: CustomBox(
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 5, right: 5),
                  //       child: DropdownButton<String>(
                  //         borderRadius: BorderRadius.circular(10),
                  //         isExpanded: true,
                  //         underline: const SizedBox(),
                  //         value: 'KG',
                  //         hint: Padding(
                  //           padding: const EdgeInsets.only(left: 10),
                  //           child: Text(
                  //             'viewModel.product.measure' ?? '',
                  //             style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
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
                  //                       ? 'Кило'
                  //                       : value == 'GR'
                  //                           ? 'Грамм'
                  //                           : value == 'LITR'
                  //                               ? 'Литр'
                  //                               : value == 'PIECE'
                  //                                   ? 'Штука'
                  //                                   : '',
                  //                   style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500)),
                  //             ),
                  //           );
                  //         }).toList(),
                  //         onChanged: (value) {},
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
    required VoidCallback onRemoveWidget,
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
                    size: 18,
                  ),
                ),
              ),
            ),
          ],

          /// remove button
          if (_barcodes.length > 1) ...[
            AppUtils.kGap12,
            SizedBox(
              height: 50,
              width: 50,
              child: Material(
                borderRadius: AppUtils.kBorderRadius8,
                color: AppColors.error300,
                child: InkWell(
                  onTap: onRemoveWidget,
                  hoverColor: AppColors.error200,
                  highlightColor: AppColors.error100,
                  splashColor: AppColors.error100,
                  borderRadius: AppUtils.kBorderRadius8,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
}
