import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/data/dtos/product_in_stocks_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_contractor/cubit/add_contractor_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/title_products.dart';
import '../../../../../app/router.gr.dart';
import '../../../../../core/constants/spaces.dart';
import '../../../../../core/enums/states.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/custom_box.dart';
import '../../../../../core/widgets/product_table_item.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../../../../data/dtos/company/company_dto.dart';
import '../../../../../data/dtos/stock_dto.dart';
import '../../../dialogs/category/bloc/category_bloc.dart';
import '../../../dialogs/prouct_detail/product_detail_dialog.dart';
import '../../reports/children/cubit/reports_cubit.dart';
import '../../search/cubit/search_bloc.dart';
import '../dialogs/currency/currency_dialog.dart';

class StockProducts extends HookWidget {
  const StockProducts(
    this.stock,
    this.organization, {
    super.key,
  });

  final StockDto stock;
  final CompanyDto organization;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final selectedFilter = useState<String>('remote');
    final supplierController = useTextEditingController();
    final categoryController = useTextEditingController();
    ThemeData themeData = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          context
              .read<SearchBloc>()
              .add(LoadMoreSearch(remote: selectedFilter.value == "remote"));
        }
      });
      context.read<AddContractorCubit>().getSuppliers();
      context.read<CategoryBloc>().add(GetCategory());
      context
          .read<SearchBloc>()
          .add(SearchRemoteTextChanged("", stockId: stock.id));
      context.read<ReportsCubit>().getReports();
      return null;
    }, const []);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeData.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppTextField(
                        radius: 8,
                        height: 50,
                        hintStyle: AppTextStyles.mType16
                            .copyWith(color: AppColors.primary500),
                        contentPadding: EdgeInsets.all(14),
                        hint: context.tr("search_product"),
                        fieldController: searchController,
                        suffix: Row(
                          children: [
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
                                      textStyle: TextStyle(fontSize: 11),
                                      controller: categoryController,
                                      onSelected: (value) {
                                        context
                                            .read<SearchBloc>()
                                            .add(SelectCategory(id: value));
                                        context.read<SearchBloc>().add(
                                            SearchRemoteTextChanged(
                                                searchController.text,
                                                stockId: stock.id,
                                                categoryId: value,
                                                clearPrevious: true));
                                      },
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        hintStyle: TextStyle(fontSize: 11),
                                        isDense: true,
                                        constraints: BoxConstraints.tight(
                                            const Size.fromHeight(35)),
                                      ),
                                      dropdownMenuEntries: [
                                        DropdownMenuEntry(
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
                            AppSpace.horizontal12,
                            BlocBuilder<AddContractorCubit, AddContractorState>(
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
                                      hintText: 'Выбор поставщика',
                                      textStyle: TextStyle(fontSize: 11),
                                      controller: supplierController,
                                      onSelected: (value) {
                                        context.read<SearchBloc>().add(
                                              SelectSupplier(id: value),
                                            );
                                        context.read<SearchBloc>().add(
                                            SearchRemoteTextChanged(
                                                searchController.text,
                                                stockId: stock.id,
                                                supplierId: value,
                                                clearPrevious: true));
                                      },
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        hintStyle: TextStyle(fontSize: 11),
                                        isDense: true,
                                        constraints: BoxConstraints.tight(
                                            const Size.fromHeight(35)),
                                      ),
                                      dropdownMenuEntries: [
                                        DropdownMenuEntry(
                                          value: null,
                                          label: 'Все поставщики',
                                        ),
                                        ...state.suppliers
                                                ?.map(
                                                  (e) => DropdownMenuEntry(
                                                    value: e.id,
                                                    label: e.name ??
                                                        e.inn ??
                                                        e.phoneNumber ??
                                                        '',
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
                            AppSpace.horizontal12,
                            IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  supplierController.clear();

                                  context.read<SearchBloc>().add(
                                        SelectSupplier(id: null),
                                      );
                                  searchController.clear();
                                  context.read<SearchBloc>().add(
                                      SearchRemoteTextChanged('',
                                          stockId: stock.id));
                                }),
                          ],
                        ),
                        onChange: (value) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (selectedFilter.value == "local") {
                              if (value.isEmpty) {
                                context
                                    .read<SearchBloc>()
                                    .add(GetLocalProducts());
                              } else {
                                context
                                    .read<SearchBloc>()
                                    .add(SearchTextChanged(value));
                              }
                            } else {
                              if (value.isEmpty) {
                                context.read<SearchBloc>().add(
                                    SearchRemoteTextChanged('',
                                        stockId: stock.id));
                              } else {
                                context.read<SearchBloc>().add(
                                    SearchRemoteTextChanged(value,
                                        stockId: stock.id));
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: () {
                      context.read<SearchBloc>().add(ExportProducts());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.primary),
                      height: 50,
                      child: Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              color: AppColors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.barcode_reader,
                              color: AppColors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: () {
                      context
                          .read<SearchBloc>()
                          .add(SearchRemoteTextChanged("", stockId: stock.id));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.primary),
                      height: 50,
                      child: Center(
                        child: Icon(
                          Icons.restart_alt,
                          size: 20,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: () {
                      router.push(AddProductRoute(
                          stock: stock, organization: organization));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary800),
                      height: 50,
                      width: context.width * .1,
                      child: Center(
                        child: Text(
                          "Добавить",
                          maxLines: 2,
                          style:
                              TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          AppSpace.vertical12,
          Expanded(
            child: CustomBox(
              child: Column(
                children: [
                  TitleProducts(
                    showSupply: true,
                  ),
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state.status == StateStatus.loading) {
                        return Expanded(
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else if (state.products?.results.isEmpty ??
                          false || state.products == null) {
                        return Expanded(
                            child:
                                Center(child: Text(context.tr("not_found"))));
                      } else if (state.status == StateStatus.loaded ||
                          state.status == StateStatus.loadingMore) {
                        return BarcodeKeyboardListener(
                          onBarcodeScanned: (value) {
                            if (value.isEmpty) value = searchController.text;
                            searchController.clear();
                            searchController.text = value;

                            context.read<SearchBloc>().add(
                                SearchRemoteTextChanged(value,
                                    stockId: stock.id));
                          },
                          child: SizedBox(
                            height: context.height - 250,
                            child: ListView.separated(
                              shrinkWrap: true,
                              controller: scrollController,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              itemBuilder: (context, index) {
                                final product = state.products?.results[index];
                                final productInStocks =
                                    product?.stocks.firstOrNull;
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
                                            ? SizedBox()
                                            : ProductDetailDialog(
                                                productDto: product),
                                      ),
                                    );
                                  },
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 2, 5, 2),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppSpace.vertical2,
                                                  Text(
                                                    "${context.tr("article")}: ${product?.vendorCode ?? 'Не найдено'}",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 9),
                                                  ),
                                                  Text(
                                                    product?.title ?? '',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12),
                                                  ),
                                                  AppSpace.vertical2,
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
                                        padding: EdgeInsets.all(8),
                                        child:
                                            Text(product?.category?.name ?? ''),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child:
                                            Text(product?.supplier?.name ?? ''),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 12, 5, 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              productInStocks?.quantity == 0
                                                  ? 'Нет в наличии'
                                                  : "Ост./Резерв: ${productInStocks?.quantity}/${productInStocks?.quantityReserve}",
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                            if ((productInStocks
                                                        ?.freeQuantity ??
                                                    0) >
                                                0)
                                              Text(
                                                productInStocks?.freeQuantity ==
                                                        0
                                                    ? ''
                                                    : "Своб. ост : ${productInStocks?.freeQuantity}",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color:
                                                        AppColors.success600),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 5, 10, 5),
                                        child: product?.price == null
                                            ? const SizedBox()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${currencyFormatter.format(product?.purchasePriceDollar).replaceAll('.', ' ')} \$",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11),
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    "${currencyFormatter.format(product?.purchasePriceUzs).replaceAll('.', ' ')} сум",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 10, 5),
                                        child: product?.price == null
                                            ? const SizedBox()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "${currencyFormatter.format(product?.priceDollar).replaceAll('.', ' ')} \$",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11),
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    "${currencyFormatter.format(product?.price).replaceAll('.', ' ')} сум",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 60,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  router.push(AddProductRoute(
                                                      product: product,
                                                      stock: stock,
                                                      organization:
                                                          organization));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary500,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              AppColors.stroke,
                                                          blurRadius: 3)
                                                    ],
                                                  ),
                                                  height: 40,
                                                  width: 40,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              AppSpace.horizontal12,
                                              GestureDetector(
                                                onTap: () async {
                                                  final bloc = context
                                                      .read<SearchBloc>();
                                                  final res = await context
                                                      .showCustomDialog(
                                                    DeleteProductWidget(),
                                                  );
                                                  if (res == null) return;

                                                  bloc.add(DeleteProduct(
                                                      product?.id ?? 0));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.error500,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              AppColors.stroke,
                                                          blurRadius: 3)
                                                    ],
                                                  ),
                                                  height: 40,
                                                  width: 40,
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  AppSpace.vertical12,
                              itemCount: state.products?.results.length ?? 0,
                            ),
                          ),
                        );
                      }
                      return Center(child: Text("Ошибка загрузки"));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteProductWidget extends StatelessWidget {
  const DeleteProductWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width / 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 24),
              Text(
                'Вы действительно хотите удалить?',
                textAlign: TextAlign.center,
                style: AppTextStyles.boldType24,
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 160,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.success500),
                      child: Text(
                        'Нет',
                        style: AppTextStyles.boldType18
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 160,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.error500),
                      child: Text(
                        'Да',
                        style: AppTextStyles.boldType18
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
