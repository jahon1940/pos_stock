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
import '../../../dialogs/search/cubit/fast_search_bloc.dart';
import '../../../dialogs/search/search_dialog.dart';

@RoutePage()
class ManagerReportScreen extends HookWidget {
  const ManagerReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final selectedFilter = useState<String>('remote');
    final supplierController = useTextEditingController();
    ThemeData themeData = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );

    final bloc = context.read<ReportManagerCubit>();
    final fromController = useTextEditingController();
    final toController = useTextEditingController();

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
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: AppColors.stroke, blurRadius: 3)
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
                    BlocBuilder<ReportManagerCubit, ReportManagerState>(
                      builder: (context, state) {
                        return Padding(
                            padding: const EdgeInsets.all(3),
                            child: GestureDetector(
                              onTap: () async {
                                final res = await showDialog(
                                  context: context,
                                  builder: (context) => BlocProvider(
                                    create: (context) => getIt<FastSearchBloc>()
                                      ..add(SearchInit(false)),
                                    child: const SearchDialog(
                                      isDialog: true,
                                      isSelect: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                  height: 40,
                                  width: context.width * .2,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        state.selectedProduct == null
                                            ? Text(
                                                "Выберите продукт",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )
                                            : SizedBox(
                                                width: context.width * .16,
                                                child: Text(
                                                  "${state.selectedProduct?.title}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<ReportManagerCubit>()
                                                .selectProduct(null);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ));
                      },
                    ),
                    BlocBuilder<ReportManagerCubit, ReportManagerState>(
                        builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                width: context.width * .2,
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<int?>(
                                  value: state.selectedManager?.id,
                                  hint: const Text(
                                    "Выбрать менеджера",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  isDense: true,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: state.managers.map((manager) {
                                    return DropdownMenuItem<int?>(
                                      value: manager.id,
                                      child: Text(
                                        manager.name ?? "Не известно",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ), // или другой читаемый текст
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    context
                                        .read<ReportManagerCubit>()
                                        .selectManager(value);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      bloc.selectFromDate(picked);

                                      fromController.text =
                                          DateFormat("dd.MM.yyyy")
                                              .format(picked);
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: AppTextField(
                                      width: 150,
                                      label: "От: ",
                                      labelStyle: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      readOnly: true,
                                      enabledBorderWith: 1,
                                      enabledBorderColor: AppColors.stroke,
                                      focusedBorderColor: AppColors.stroke,
                                      focusedBorderWith: 1,
                                      fieldController: fromController,
                                    ),
                                  ),
                                ),
                              ),
                              AppSpace.horizontal12,
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (picked != null) {
                                      bloc.selectToDate(picked);
                                      toController.text =
                                          DateFormat("dd.MM.yyyy")
                                              .format(picked);
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: AppTextField(
                                      width: 150,
                                      label: "До: ",
                                      labelStyle: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      readOnly: true,
                                      enabledBorderWith: 1,
                                      enabledBorderColor: AppColors.stroke,
                                      focusedBorderColor: AppColors.stroke,
                                      focusedBorderWith: 1,
                                      fieldController: toController,
                                    ),
                                  ),
                                ),
                              ),
                              AppSpace.horizontal12,
                              GestureDetector(
                                onTap: () async {
                                  bloc.getReport();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: context.primary),
                                  height: 50,
                                  width: context.width * .1,
                                  child: Center(
                                    child: Text(
                                      "Сформировать",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: context.onPrimary),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ),
              AppSpace.vertical12,
              Expanded(
                child: CustomBox(
                  child: Column(
                    children: [
                      AppSpace.vertical2,
                      TableTitleProducts(
                        fillColor: AppColors.stroke,
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                          5: FlexColumnWidth(2),
                          6: FlexColumnWidth(2),
                        },
                        titles: [
                          context.tr("Название"),
                          context.tr("Операция"),
                          context.tr("Кол-во"),
                          context.tr("Приходная цена"),
                          context.tr("Цена продажи"),
                          context.tr("Сумма"),
                          context.tr("Прибыль"),
                        ],
                      ),
                      BlocBuilder<ReportManagerCubit, ReportManagerState>(
                          builder: (context, state) {
                        if (state.status == StateStatus.loaded &&
                                state.managerReports == null ||
                            (state.managerReports?.isEmpty ?? true)) {
                          return Center(child: Text(context.tr("not_found")));
                        } else if (state.status == StateStatus.loading) {
                          return Expanded(
                              child:
                                  Center(child: CircularProgressIndicator()));
                        } else if (state.status == StateStatus.loaded) {
                          return SizedBox(
                            height: context.height - 250,
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8.0),
                              itemBuilder: (context, index) {
                                ManagerReportDto managerReport =
                                    state.managerReports![index];
                                return Material(
                                  color: Colors.transparent,
                                  child: TableProductItem(
                                    columnWidths: const {
                                      0: FlexColumnWidth(4),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(2),
                                      5: FlexColumnWidth(2),
                                      6: FlexColumnWidth(2),
                                    },
                                    onTap: () async {},
                                    children: [
                                      TableItem(
                                        text: managerReport.title ?? "",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                managerReport.receiptType ?? "",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              AppSpace.vertical6,
                                              Text(
                                                FormatterService()
                                                    .dateFormatter(managerReport
                                                        .createdAt),
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              AppSpace.vertical6,
                                              Text(
                                                "чек: ${managerReport.receiptId}",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      TableItem(
                                        text: managerReport.quantity
                                                ?.toString() ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TableItem(
                                        text: FormatterService().formatNumber(
                                            (managerReport.priceCurrent
                                                    ?.toString() ??
                                                "0")),
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TableItem(
                                        text: FormatterService().formatNumber(
                                            (managerReport.price?.toString() ??
                                                "0")),
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TableItem(
                                        text: FormatterService().formatNumber(
                                            (managerReport.total?.toString() ??
                                                "0")),
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TableItem(
                                        text: FormatterService().formatNumber(
                                            (managerReport.profit?.toString() ??
                                                "0")),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary800),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  AppSpace.vertical12,
                              itemCount: state.managerReports!.length,
                            ),
                          );
                        }

                        return Expanded(
                            child: Center(child: Text("Ошибка загрузки")));
                      }),
                      BlocBuilder<ReportManagerCubit, ReportManagerState>(
                        builder: (context, state) {
                          return state.managerReportsTotal == null ||
                                  state.managerReports!.isEmpty ||
                                  state.selectedProduct != null
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 500,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 16, 8, 0),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: AppColors.primary100
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: TableProductItem(
                                            columnWidths: const {
                                              0: FlexColumnWidth(4),
                                              1: FlexColumnWidth(4),
                                              2: FlexColumnWidth(4),
                                            },
                                            onTap: () {},
                                            children: [
                                              SizedBox(
                                                height: 60,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 5, 5),
                                                  child: Text(
                                                    "Всего продуктов: \n( ${state.managerReportsTotal?.totalQuantity} )",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 5, 5),
                                                  child: Text(
                                                    "Сумма продаж: \n( ${state.managerReportsTotal?.totalSale} )",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 5, 5),
                                                  child: Text(
                                                    "Прибыль: \n( ${state.managerReportsTotal?.totalProfit} )",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
