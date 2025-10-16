import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/dictionary.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/table_title_widget.dart';

import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../data/dtos/product_dto.dart';
import '../../../../dialogs/category/bloc/category_bloc.dart';
import '../../../search/cubit/search_bloc.dart';
import '../../../supplier/children/cubit/supplier_cubit.dart';
import 'add_product_screen.dart';
import 'widgets/product_item_widget.dart';

class StockProductsScreen extends HookWidget {
  const StockProductsScreen({
    required this.navigationKey,
    required this.stock,
    required this.organization,
    super.key,
  });

  final GlobalKey<NavigatorState> navigationKey;
  final StockDto stock;
  final CompanyDto organization;

  @override
  Widget build(
    BuildContext context,
  ) {
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final selectedFilter = useState<String>('remote');
    final supplierController = useTextEditingController();
    final categoryController = useTextEditingController();
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          context.searchBloc.add(LoadMoreSearch(remote: selectedFilter.value == 'remote'));
        }
      });
      context.supplierBloc.getSuppliers();
      context.categoryBloc.add(const GetCategoryEvent());
      context.searchBloc.add(SearchRemoteTextChangedEvent('', stockId: stock.id));
      context.reportsBloc.getReports();
      return null;
    }, const []);

    return Scaffold(
      body: Padding(
        padding: AppUtils.kPaddingAll10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// header
            Container(
              height: 60,
              padding: AppUtils.kPaddingAll6,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: AppUtils.kBorderRadius12,
                boxShadow: [BoxShadow(color: context.theme.dividerColor, blurRadius: 3)],
              ),
              child: Row(
                children: [
                  // const BackButtonWidget(),
                  // AppUtils.kGap6,

                  ///
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.opcty(.3),
                        borderRadius: AppUtils.kBorderRadius12,
                      ),
                      child: AppTextField(
                        radius: 12,
                        hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                        contentPadding: const EdgeInsets.all(14),
                        hint: context.tr('search_product'),
                        fieldController: searchController,
                        suffix: Row(
                          children: [
                            ///
                            BlocBuilder<CategoryBloc, CategoryState>(
                              builder: (context, state) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: AppUtils.kBorderRadius12,
                                ),
                                child: DropdownMenu<int?>(
                                  width: 220,
                                  hintText: 'Выбор категории',
                                  textStyle: const TextStyle(fontSize: 11),
                                  controller: categoryController,
                                  onSelected: (value) {
                                    context.searchBloc
                                      ..add(SelectCategory(id: value))
                                      ..add(
                                        SearchRemoteTextChangedEvent(
                                          searchController.text,
                                          stockId: stock.id,
                                          categoryId: value,
                                          clearPrevious: true,
                                        ),
                                      );
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
                                            .map((e) => DropdownMenuEntry(value: e.id, label: e.name))
                                            .toList() ??
                                        []
                                  ],
                                ),
                              ),
                            ),

                            ///
                            AppUtils.kGap6,
                            BlocBuilder<SupplierCubit, SupplierState>(
                              builder: (context, state) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: AppUtils.kBorderRadius12,
                                ),
                                child: DropdownMenu<int?>(
                                  width: 220,
                                  hintText: 'Выбор поставщика',
                                  textStyle: const TextStyle(fontSize: 11),
                                  controller: supplierController,
                                  onSelected: (value) {
                                    context.searchBloc
                                      ..add(SelectSupplier(id: value))
                                      ..add(SearchRemoteTextChangedEvent(
                                        searchController.text,
                                        stockId: stock.id,
                                        supplierId: value,
                                        clearPrevious: true,
                                      ));
                                  },
                                  inputDecorationTheme: InputDecorationTheme(
                                    hintStyle: const TextStyle(fontSize: 11),
                                    isDense: true,
                                    constraints: BoxConstraints.tight(const Size.fromHeight(35)),
                                  ),
                                  dropdownMenuEntries: [
                                    const DropdownMenuEntry(
                                      value: null,
                                      label: 'Все поставщики',
                                    ),
                                    ...state.suppliers
                                            ?.map(
                                              (e) => DropdownMenuEntry(
                                                value: e.id,
                                                label: e.name ?? e.inn ?? e.phoneNumber ?? '',
                                              ),
                                            )
                                            .toList() ??
                                        []
                                  ],
                                ),
                              ),
                            ),

                            ///
                            AppUtils.kGap6,
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                supplierController.clear();
                                context.searchBloc.add(SelectSupplier());
                                searchController.clear();
                                context.searchBloc.add(SearchRemoteTextChangedEvent('', stockId: stock.id));
                              },
                            ),
                          ],
                        ),
                        onChange: (value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (selectedFilter.value == 'local') {
                              context.searchBloc
                                  .add(value.isEmpty ? GetLocalProducts() : SearchTextChangedEvent(value));
                            } else {
                              context.searchBloc.add(value.isEmpty
                                  ? SearchRemoteTextChangedEvent('', stockId: stock.id)
                                  : SearchRemoteTextChangedEvent(value, stockId: stock.id));
                            }
                          });
                        },
                      ),
                    ),
                  ),

                  ///
                  AppUtils.kGap6,
                  GestureDetector(
                    onTap: () => context.searchBloc.add(ExportProducts()),
                    child: Container(
                      height: 48,
                      padding: AppUtils.kPaddingHor12,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: AppUtils.kBorderRadius12,
                        color: context.primary,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.download, color: AppColors.white, size: 16),
                          SizedBox(width: 6),
                          Icon(Icons.barcode_reader, color: AppColors.white, size: 16),
                        ],
                      ),
                    ),
                  ),

                  ///
                  AppUtils.kGap6,
                  GestureDetector(
                    onTap: () => context.searchBloc.add(SearchRemoteTextChangedEvent('', stockId: stock.id)),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: AppUtils.kBorderRadius12,
                        color: context.primary,
                      ),
                      child: const Icon(Icons.restart_alt, size: 20, color: AppColors.white),
                    ),
                  ),

                  ///
                  AppUtils.kGap6,
                  GestureDetector(
                    onTap: _push,
                    child: Container(
                      height: 48,
                      width: context.width * .1,
                      decoration: const BoxDecoration(
                        borderRadius: AppUtils.kBorderRadius12,
                        color: AppColors.primary800,
                      ),
                      child: Center(
                        child: Text(
                          'Добавить',
                          style: TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// body
            AppUtils.kGap12,
            Expanded(
              child: CustomBox(
                padding: AppUtils.kPaddingAll12.withB0,
                child: Column(
                  children: [
                    TableTitleWidget(
                      columnWidths: {
                        0: const FlexColumnWidth(6),
                        1: const FlexColumnWidth(4),
                        2: const FlexColumnWidth(3),
                        3: const FlexColumnWidth(3),
                        4: const FlexColumnWidth(3),
                        5: const FlexColumnWidth(3),
                        6: const FlexColumnWidth(3),
                      },
                      titles: [
                        '${context.tr("name")}/${context.tr("article")}',
                        'Категория',
                        'Поставщик',
                        context.tr('count_short'),
                        context.tr('priceFrom'),
                        context.tr('priceTo'),
                        'Действия',
                      ],
                    ),

                    ///
                    AppUtils.kGap12,
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        final products = state.products?.results ?? [];
                        return Expanded(
                          child: state.status.isLoading && products.isEmpty
                              ? const Center(child: CupertinoActivityIndicator())
                              : products.isEmpty
                                  ? Center(child: Text(context.tr(Dictionary.not_found)))
                                  : BarcodeKeyboardListener(
                                      onBarcodeScanned: (value) {
                                        if (value.isEmpty) value = searchController.text;
                                        searchController.clear();
                                        searchController.text = value;
                                        context.searchBloc.add(SearchRemoteTextChangedEvent(value, stockId: stock.id));
                                      },
                                      child: Material(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          controller: scrollController,
                                          padding: AppUtils.kPaddingB12,
                                          itemCount: products.length,
                                          separatorBuilder: (_, __) => AppUtils.kGap12,
                                          itemBuilder: (context, index) => ProductItemWidget(
                                            navigationKey: navigationKey,
                                            product: products.elementAt(index),
                                          ),
                                        ),
                                      ),
                                    ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _push([
    ProductDto? product,
  ]) =>
      navigationKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => AddProductScreen(product: product),
        ),
      );
}
