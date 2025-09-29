import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/core/widgets/table_item.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/data/dtos/manager_report/manager_report_dto.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/report_dialog/cubit/report_manager_cubit.dart';

import '../../../../../app/di.dart';
import '../../../../../app/router.dart';
import '../../../../../core/styles/text_style.dart';
import '../../../dialogs/category/bloc/category_bloc.dart';
import '../../../dialogs/search/cubit/fast_search_bloc.dart';
import '../../../dialogs/search/search_dialog.dart';
import '../../search/cubit/search_bloc.dart';
import '../../stock/screens/supplier/cubit/supplier_cubit.dart';
import 'cubit/reports_cubit.dart';

@RoutePage()
class ProductReportScreen extends HookWidget {
  const ProductReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<ReportsCubit>().getReports();
      context.read<SupplierCubit>().getSuppliers();
      context.read<CategoryBloc>().add(GetCategory());
      return null;
    }, const []);
    ThemeData themeData = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );
    final supplierController = useTextEditingController();
    final categoryController = useTextEditingController();
    return SelectionArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: AppColors.stroke, blurRadius: 3)
                  ],
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary500,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.stroke, blurRadius: 3)
                                ],
                              ),
                              child: InkWell(
                                onTap: () => router.push(ReportsRoute()),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 10, 12),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Отчеты по продуктам",
                            style: AppTextStyles.boldType18
                                .copyWith(color: AppColors.primary500),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Row(
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
                                    context
                                        .read<ReportsCubit>()
                                        .getReports(categoryId: value);
                                  },
                                  inputDecorationTheme: InputDecorationTheme(
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
                        BlocBuilder<SupplierCubit, SupplierState>(
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
                                    context
                                        .read<ReportsCubit>()
                                        .getReports(supplierId: value);
                                  },
                                  inputDecorationTheme: InputDecorationTheme(
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
                        AppSpace.horizontal24,
                        GestureDetector(
                          onTap: () async {
                            context.read<ReportsCubit>().getReports();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: context.primary),
                            height: 50,
                            width: context.width * .10,
                            child: Center(
                              child: Text(
                                "Сформировать",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 13, color: context.onPrimary),
                              ),
                            ),
                          ),
                        ),
                        AppSpace.horizontal24,
                      ],
                    ),
                  ],
                ),
              ),
              AppSpace.vertical12,
              Expanded(
                child: CustomBox(
                  child: Column(
                    children: [
                      AppSpace.vertical2,
                      BlocBuilder<ReportsCubit, ReportsState>(
                        builder: (context, state) {
                          if (state.status == StateStatus.loading) {
                            return Expanded(
                                child: const Center(
                                    child: CircularProgressIndicator()));
                          } else if (state.info == null) {
                            return Expanded(
                                child: Center(
                                    child: Text(context.tr("not_found"))));
                          } else if (state.status == StateStatus.loaded ||
                              state.status == StateStatus.loadingMore) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.primary100.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: TableProductItem(
                                  columnWidths: const {
                                    0: FlexColumnWidth(4),
                                    1: FlexColumnWidth(4),
                                    2: FlexColumnWidth(4),
                                    3: FlexColumnWidth(4),
                                    4: FlexColumnWidth(4),
                                  },
                                  onTap: () {},
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 5, 5, 5),
                                        child: Text(
                                          "Всего продуктов: \n( ${state.info?.productsCount} )",
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: BlocBuilder<SupplierCubit,
                                            SupplierState>(
                                          builder: (context, state) {
                                            return Text(
                                              "Всего поставщиков: \n ( ${state.suppliers?.length ?? ""} )",
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 5, 5, 5),
                                        child: Text(
                                          "Сумма продуктов: \n( ${state.info?.totalQuantity} )",
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 2, 10, 2),
                                        child: state.info == null
                                            ? const SizedBox()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Сумма:",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        "${currencyFormatter.format(state.info?.totalPurchasePriceDollar).replaceAll('.', ' ')} \$",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    "${currencyFormatter.format(state.info?.totalPurchasePrice).replaceAll('.', ' ')} сум",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 2, 10, 2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Сумма:",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  "${currencyFormatter.format(state.info?.totalPriceDollar).replaceAll('.', ' ')} \$",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Text(
                                              "${currencyFormatter.format(state.info?.totalPrice).replaceAll('.', ' ')} сум",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
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
                          return Center(child: Text("Ошибка загрузки"));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AppBarTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.1) // выбранный — подсвеченный
              : Colors.white, // не выбранный — белый
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
