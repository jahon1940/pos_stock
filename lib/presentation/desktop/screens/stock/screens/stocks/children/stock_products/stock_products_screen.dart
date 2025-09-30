import 'package:auto_route/auto_route.dart';
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

import '../../../../../../../../app/router.dart';
import '../../../../../../../../app/router.gr.dart';
import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../dialogs/category/bloc/category_bloc.dart';
import '../../../../../../dialogs/prouct_detail/product_detail_dialog.dart';
import '../../../../../search/cubit/search_bloc.dart';
import '../../../../../supplier/children/cubit/supplier_cubit.dart';
import '../../../../widgets/back_button_widget.dart';
import '../../../../widgets/title_products.dart';
import '../../widgets/delete_product_widget.dart';

@RoutePage()
class StockProductsScreen extends HookWidget {
  const StockProductsScreen(
    this.stock,
    this.organization, {
    super.key,
  });

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
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          context.searchBloc.add(LoadMoreSearch(remote: selectedFilter.value == "remote"));
        }
      });
      context.supplierBloc.getSuppliers();
      context.categoryBloc.add(GetCategory());
      context.searchBloc.add(SearchRemoteTextChanged("", stockId: stock.id));
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
                  ///
                  const BackButtonWidget(),

                  ///
                  AppUtils.kGap6,
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
                        hint: context.tr("search_product"),
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
                                    context.read<SearchBloc>().add(SelectCategory(id: value));
                                    context.read<SearchBloc>().add(SearchRemoteTextChanged(searchController.text,
                                        stockId: stock.id, categoryId: value, clearPrevious: true));
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
                                    context.searchBloc.add(SelectSupplier(id: value));
                                    context.searchBloc.add(SearchRemoteTextChanged(
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
                                context.searchBloc.add(SearchRemoteTextChanged('', stockId: stock.id));
                              },
                            ),
                          ],
                        ),
                        onChange: (value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (selectedFilter.value == "local") {
                              context.searchBloc.add(value.isEmpty ? GetLocalProducts() : SearchTextChanged(value));
                            } else {
                              context.searchBloc.add(value.isEmpty
                                  ? SearchRemoteTextChanged('', stockId: stock.id)
                                  : SearchRemoteTextChanged(value, stockId: stock.id));
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
                    onTap: () => context.searchBloc.add(SearchRemoteTextChanged("", stockId: stock.id)),
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
                    onTap: () => router.push(AddProductRoute(stock: stock, organization: organization)),
                    child: Container(
                      height: 48,
                      width: context.width * .1,
                      decoration: const BoxDecoration(
                        borderRadius: AppUtils.kBorderRadius12,
                        color: AppColors.primary800,
                      ),
                      child: Center(
                        child: Text(
                          "Добавить",
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
                    const TitleProducts(showSupply: true),

                    ///
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state.status.isLoading) {
                          return const Expanded(child: Center(child: CupertinoActivityIndicator()));
                        } else if ((state.products?.results ?? []).isEmpty || state.products == null) {
                          return Expanded(child: Center(child: Text(context.tr(Dictionary.not_found))));
                        } else if (state.status.isLoaded || state.status.isLoadingMore) {
                          return Expanded(
                            child: BarcodeKeyboardListener(
                              onBarcodeScanned: (value) {
                                if (value.isEmpty) value = searchController.text;
                                searchController.clear();
                                searchController.text = value;
                                context.searchBloc.add(SearchRemoteTextChanged(value, stockId: stock.id));
                              },
                              child: SizedBox(
                                height: context.height - 250,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  itemCount: state.products?.results.length ?? 0,
                                  separatorBuilder: (_, __) => AppUtils.kGap12,
                                  itemBuilder: (context, index) {
                                    final product = state.products?.results[index];
                                    final productInStocks = product?.stocks.firstOrNull;
                                    return TableProductItem(
                                      columnWidths: const {
                                        0: FlexColumnWidth(6),
                                        1: FlexColumnWidth(4),
                                        2: FlexColumnWidth(3),
                                        3: FlexColumnWidth(3),
                                        4: FlexColumnWidth(3),
                                        5: FlexColumnWidth(3),
                                        6: FlexColumnWidth(3),
                                      },
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                            child: product == null
                                                ? const SizedBox()
                                                : ProductDetailDialog(productDto: product),
                                          ),
                                        );
                                      },
                                      children: [
                                        SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 2, 5, 2),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      AppUtils.kGap12,
                                                      Text(
                                                        "${context.tr("article")}: ${product?.vendorCode ?? 'Не найдено'}",
                                                        maxLines: 1,
                                                        style:
                                                            const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
                                                      ),
                                                      Text(
                                                        product?.title ?? '',
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style:
                                                            const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                                      ),
                                                      AppUtils.kGap12,
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(product?.category?.name ?? ''),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(product?.supplier?.name ?? ''),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 12, 5, 5),
                                            child: Column(
                                              children: [
                                                Text(
                                                  productInStocks?.quantity == 0
                                                      ? 'Нет в наличии'
                                                      : "Ост./Резерв: ${productInStocks?.quantity}/${productInStocks?.quantityReserve}",
                                                  style: const TextStyle(fontSize: 11),
                                                ),
                                                if ((productInStocks?.freeQuantity ?? 0) > 0)
                                                  Text(
                                                    productInStocks?.freeQuantity == 0
                                                        ? ''
                                                        : "Своб. ост : ${productInStocks?.freeQuantity}",
                                                    style: const TextStyle(fontSize: 11, color: AppColors.success600),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                                            child: product?.price == null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${currencyFormatter.format(product?.purchasePriceDollar).replaceAll('.', ' ')} \$",
                                                        style:
                                                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                                      ),
                                                      const Divider(),
                                                      Text(
                                                        "${currencyFormatter.format(product?.purchasePriceUzs).replaceAll('.', ' ')} сум",
                                                        style:
                                                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                            child: product?.price == null
                                                ? const SizedBox()
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${currencyFormatter.format(product?.priceDollar).replaceAll('.', ' ')} \$",
                                                        style:
                                                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                                      ),
                                                      const Divider(),
                                                      Text(
                                                        "${currencyFormatter.format(product?.price).replaceAll('.', ' ')} сум",
                                                        style:
                                                            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),

                                        /// buttons
                                        Container(
                                          height: 60,
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () async => router.push(AddProductRoute(
                                                  product: product,
                                                  stock: stock,
                                                  organization: organization,
                                                )),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary500,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      const BoxShadow(color: AppColors.stroke, blurRadius: 3)
                                                    ],
                                                  ),
                                                  height: 40,
                                                  width: 40,
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  final bloc = context.read<SearchBloc>();
                                                  final res =
                                                      await context.showCustomDialog(const DeleteProductWidget());
                                                  if (res == null) return;
                                                  bloc.add(DeleteProduct(product?.id ?? 0));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.error500,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      const BoxShadow(color: AppColors.stroke, blurRadius: 3)
                                                    ],
                                                  ),
                                                  height: 40,
                                                  width: 40,
                                                  child: const Icon(Icons.delete, color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                        return const Expanded(child: Center(child: Text("Ошибка загрузки")));
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
}
