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
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';

import '../../../../../app/router.dart';
import '../../../../../data/dtos/report/retail_report.dart';
import 'cubit/reports_cubit.dart';

@RoutePage()
class RetailReportScreen extends HookWidget {
  const RetailReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );

    final bloc = context.read<ReportsCubit>();
    final fromController = useTextEditingController();
    final toController = useTextEditingController();

    useEffect(() {
      context.read<ReportsCubit>().initial();
      return null;
    }, const []);
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
                            "Розничная выручка",
                            style: AppTextStyles.boldType18
                                .copyWith(color: AppColors.primary500),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ReportsCubit, ReportsState>(
                        builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                  bloc.getTotalReport();
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
                  child: BlocBuilder<ReportsCubit, ReportsState>(
                      builder: (context, state) {
                    if (state.status == StateStatus.loaded &&
                            state.reportTotal == null ||
                        (state.reportTotal?.isEmpty ?? true)) {
                      return Center(child: Text(context.tr("not_found")));
                    } else if (state.status == StateStatus.loading) {
                      return Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    } else if (state.status == StateStatus.loaded) {
                      return state.dateTo == null || state.dateFrom == null
                          ? SizedBox()
                          : SizedBox(
                              height: context.height - 250,
                              width: context.width,
                              child: SizedBox(
                                width: 500,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  padding: const EdgeInsets.only(bottom: 100),
                                  itemBuilder: (context, index) {
                                    RetailReportTotal report =
                                        state.reportTotal![index];
                                    int length = state.reportTotal![index]
                                        .posData.paymentTypeTotals.length;
                                    return SizedBox(
                                      width: 500,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 2, 0, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 0, 0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Касса:  ",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    report.posName,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primary500,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            AppSpace.vertical2,
                                            SizedBox(
                                              width: 450,
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                itemBuilder: (context, index) {
                                                  PaymentTypeTotal
                                                      paymentTypeTotals = report
                                                              .posData
                                                              .paymentTypeTotals[
                                                          index];
                                                  length = report.posData
                                                      .paymentTypeTotals.length;
                                                  return Material(
                                                    color: Colors.transparent,
                                                    child: TableProductItem(
                                                      columnWidths: const {
                                                        0: FlexColumnWidth(4),
                                                      },
                                                      onTap: () async {},
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child:
                                                              IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 250,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Вид оплаты чека:",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      AppSpace
                                                                          .horizontal6,
                                                                      Text(
                                                                        paymentTypeTotals
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                VerticalDivider(
                                                                  thickness: 2,
                                                                  width: 50,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(
                                                                    "${currencyFormatter.format(paymentTypeTotals.total).replaceAll('.', ' ')} ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        AppSpace.vertical2,
                                                itemCount: length,
                                              ),
                                            ),
                                            AppSpace.vertical2,
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 2, 0, 0),
                                              child: SizedBox(
                                                width: 390,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Общая сумма:",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    AppSpace.horizontal6,
                                                    Text(
                                                      "${currencyFormatter.format(report.posData.paymentTypeTotalsSum).replaceAll('.', ' ')} ",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .primary500,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      AppSpace.vertical2,
                                  itemCount: state.reportTotal!.length == 3
                                      ? state.reportTotal!.length
                                      : 1,
                                ),
                              ),
                            );
                    }

                    return Expanded(
                        child: Center(child: Text("Ошибка загрузки")));
                  }),
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
