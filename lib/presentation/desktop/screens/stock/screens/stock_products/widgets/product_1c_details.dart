import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/data/dtos/brand/brand_dto.dart';
import 'package:hoomo_pos/data/dtos/category/category_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/brands/cubit/brand_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/country/cubit/country_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stock_products/widgets/select_item_dialog.dart';

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
  String _selectedCategoryName = '';
  String _selectedBrandName = '';
  late final TextEditingController _countryController;
  late final TextEditingController _nameController;
  late final TextEditingController _vendorCodeController;
  List<String> _barcodes = [];

  @override
  void initState() {
    super.initState();
    _countryController = TextEditingController();
    _nameController = TextEditingController();
    _barcodes.add(BarcodeIdGenerator.generateRandom13DigitNumber());
    context.productBloc.setCreateProductData(barcodes: _barcodes);
    _vendorCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _countryController.dispose();
    _nameController.dispose();
    _vendorCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocConsumer<ProductCubit, ProductState>(
        listenWhen: (p, c) => !p.isProductDataLoaded && c.isProductDataLoaded,
        listener: (context, state) {
          _selectedCategoryName = state.createProductDataDto.categoryName;
          // _brandController.text = state.createProductDataDto;  // todo
          // _countryController.text = state.createProductDataDto;  // todo
          _nameController.text = state.createProductDataDto.name;
          _barcodes = List.from(state.createProductDataDto.barcodes);
          _vendorCodeController.text = state.createProductDataDto.vendorCode;
        },
        builder: (context, state) => CustomBox(
          padding: AppUtils.kPaddingAll12,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// category

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Категория: ${product?.category?.name ?? ''}',
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                      ),
                    ),

                    ///
                    AppUtils.kGap20,
                    Expanded(
                      flex: 3,
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          final categories = state.categories?.results ?? [];
                          return SizedBox(
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
                                    builder: (_) => SelectItemDialog(categories),
                                  );
                                  if (item.isNotNull) {
                                    setState(() {});
                                    _selectedCategoryName = item!.name;
                                    context.productBloc.setCreateProductData(
                                      categoryId: item.id,
                                      categoryName: item.name,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                /// brand
                AppUtils.kGap12,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Бренд: ${product?.brand?.name ?? ''}',
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                      ),
                    ),

                    ///
                    AppUtils.kGap20,
                    Expanded(
                      flex: 3,
                      child: BlocBuilder<BrandCubit, BrandState>(
                        builder: (context, state) {
                          final brands = state.brands?.results ?? [];
                          return SizedBox(
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
                                    builder: (_) => SelectItemDialog(brands),
                                  );
                                  if (item.isNotNull) {
                                    setState(() {});
                                    _selectedBrandName = item!.name;
                                    context.productBloc.setCreateProductData(
                                      brandId: item.id,
                                      brandName: item.name,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                /// country
                AppUtils.kGap12,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Страна производства: ${product?.madeIn?.name ?? ''}',
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
                      ),
                    ),

                    ///
                    AppUtils.kGap20,
                    Expanded(
                      flex: 3,
                      child: BlocBuilder<CountryCubit, CountryState>(
                        builder: (context, state) {
                          final countries = state.countries?.results ?? [];
                          return DropdownMenu<int?>(
                            width: 220,
                            hintText: 'Выбор cтрана',
                            textStyle: const TextStyle(fontSize: 11),
                            controller: _countryController,
                            onSelected: (value) => context.productBloc.setCreateProductData(
                              countryId: value,
                              countryName: _countryController.text,
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
                                label: 'Все cтрана',
                              ),
                              ...countries.map((e) => DropdownMenuEntry(value: e.id, label: e.name ?? ''))
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                ///
                AppUtils.kGap20,
                AppTextField(
                  prefix: Icon(Icons.title, color: context.primary),
                  fieldController: _nameController,
                  width: double.maxFinite,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  label: 'Название Продукта ...',
                  alignLabelWithHint: true,
                  style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                  onChange: (value) => context.productBloc.setCreateProductData(name: value),
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
                AppUtils.kGap20,
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
                        label: 'Артикул продукта...',
                        alignLabelWithHint: true,
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                        onChange: (value) => context.productBloc.setCreateProductData(vendorCode: value),
                      ),
                    ),
                    // AppUtils.kMainObjectsGap,
                    // Expanded(
                    //   child: AppTextField(
                    //     prefix: Icon(
                    //       Icons.onetwothree,
                    //       color: context.primary,
                    //     ),
                    //     // fieldController: _quantityController,
                    //     width: double.maxFinite,
                    //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    //     label: 'Количество...',
                    //     alignLabelWithHint: true,
                    //     style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                    //   ),
                    // ),
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
