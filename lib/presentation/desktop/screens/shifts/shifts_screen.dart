import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:hoomo_pos/presentation/desktop/screens/shifts/cubit/shift_cubit.dart';

import '../../../../core/styles/colors.dart';
import '../../../../core/styles/text_style.dart';
import '../../widgets/receipts/bottom_zig_zag_clipper.dart';
import '../../widgets/receipts/receipt_text.dart';
import '../../widgets/receipts/top_zig_zag_clipper.dart';

@RoutePage()
class ShiftsScreen extends HookWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<ShiftCubit>().loadShiftInfo();
      return null;
    }, []);

    return Scaffold(
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   surfaceTintColor: Colors.transparent,
        //   backgroundColor: Colors.transparent,
        //   automaticallyImplyLeading: false,
        //   actions: [
        //     /*ShiftButton(type: 'cash_in'),
        //     ShiftButton(type: 'cash_out'),*/
        //     Container(
        //       width: 150,
        //       height: 45,
        //       margin: const EdgeInsets.all(10),
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: AppColors.primary700,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(12),
        //           ),
        //         ),
        //         onPressed: () {
        //           String day = DateTime.now().day.toString();
        //           String month = DateTime.now().month.toString();
        //           String year = DateTime.now().year.toString();
        //
        //           showDialog(
        //             context: context,
        //             builder: (context) => AlertDialog(
        //               title: const Text('Выберите дату',
        //                   style: TextStyle(fontSize: 16)),
        //               content: SizedBox(
        //                 height: 100,
        //                 child: DropdownDatePicker(
        //                   isExpanded: true,
        //                   dateformatorder: OrderFormat.DMY,
        //                   isDropdownHideUnderline: true,
        //                   isFormValidator: false,
        //                   startYear: 2025,
        //                   endYear: 2035,
        //                   width: 5,
        //                   selectedDay: DateTime.now().day,
        //                   selectedMonth: DateTime.now().month,
        //                   selectedYear: DateTime.now().year,
        //                   onChangedDay: (value) {
        //                     day = value ?? DateTime.now().day.toString();
        //                   },
        //                   onChangedMonth: (value) {
        //                     month = value ?? DateTime.now().month.toString();
        //                   },
        //                   onChangedYear: (value) {
        //                     year = value ?? DateTime.now().year.toString();
        //                   },
        //                   boxDecoration: BoxDecoration(
        //                     border: Border.all(color: Colors.grey, width: 0.5),
        //                     borderRadius:
        //                         const BorderRadius.all(Radius.circular(12)),
        //                   ),
        //                   inputDecoration:
        //                       const InputDecoration(border: InputBorder.none),
        //                   showDay: true,
        //                   dayFlex: 2,
        //                   locale: "ru_RU",
        //                   hintDay: 'День',
        //                   hintMonth: 'Месяц',
        //                   hintYear: 'Год',
        //                   textStyle: const TextStyle(fontSize: 12),
        //                   hintTextStyle:
        //                       const TextStyle(color: Colors.grey, fontSize: 12),
        //                 ),
        //               ),
        //               actions: [
        //                 TextButton(
        //                   onPressed: () => Navigator.pop(context),
        //                   child: const Text('Отмена'),
        //                 ),
        //                 ElevatedButton(
        //                   onPressed: () {
        //                     context
        //                         .read<ShiftCubit>()
        //                         .downloadReport("$year-$month-$day");
        //                     Navigator.pop(context);
        //                   },
        //                   child: const Text('Скачать'),
        //                 ),
        //               ],
        //             ),
        //           );
        //         },
        //         child: Text("Отчет", style: AppTextStyles.boldType16),
        //       ),
        //     )
        //   ],
        // ),
        body: BlocBuilder<ShiftCubit, ShiftState>(builder: (context, state) {
          if (state.status == StateStatus.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  if (state.statusText != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "${state.statusText ?? "Загрузка"}: ${state.progress ?? 0}%"),
                    ),
                ],
              ),
            );
          } else if (state.status == StateStatus.loaded && state.isOpen) {
            return ListView(children: [
              Column(children: [
                Container(
                    width: 400,
                    margin: const EdgeInsets.only(top: 15),
                    child: ClipPath(
                        clipper: TopZigzagClipper(),
                        child: Container(color: Colors.white, height: 10))),
                Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    width: 400,
                    padding: const EdgeInsets.only(top: 20, bottom: 0),
                    child: Column(children: [
                      Text(context.tr('z_report'),
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      const SizedBox(height: 10),
                      Text(state.zReport?.companyName ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text(state.zReport?.stockName ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text(state.zReport?.stockAddress ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ])),
                Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    width: 400,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(children: [
                      ReceiptText(
                        titleZ: context.tr('open_date'),
                        infoZ: state.zReport?.openTime ??
                            DateFormat('dd.MM.yyyy HH:mm:ss')
                                .format(DateTime.now())
                                .toString(),
                      ),
                      ReceiptText(
                        titleZ: context.tr('tin_pinfl'),
                        infoZ: state.zReport?.companyTin ?? "",
                      ),
                      ReceiptText(
                        titleZ: context.tr('cashier'),
                        infoZ: state.zReport?.cashier ?? "",
                      ),
                      ReceiptText(
                        titleZ: context.tr('shift'),
                        infoZ: state.zReport?.number.toString() ?? "1",
                      ),
                      Divider(
                          endIndent: 8,
                          indent: 8,
                          thickness: 1,
                          color: Colors.grey[500]),
                      Text("Оплата", style: AppTextStyles.boldType14),
                      ReceiptText(
                        titleZ: context.tr('sales_count'),
                        infoZ: state.zReport?.totalSaleCount.toString() ?? "0",
                      ),
                      ReceiptText(
                        titleZ: context.tr('cash'),
                        infoZ: FormatterService().formatNumber(
                            ((state.zReport?.totalSaleCash ?? 0) / 100)
                                .toString()),
                      ),
                      ReceiptText(
                        titleZ: context.tr('card_payment'),
                        infoZ: FormatterService().formatNumber(
                            ((state.zReport?.totalSaleCard ?? 0) / 100)
                                .toString()),
                      ),
                      ReceiptText(
                        titleZ: context.tr('vat'),
                        infoZ: FormatterService().formatNumber(
                            ((state.zReport?.totalSaleVAT ?? 0) / 100)
                                .toString()),
                      ),
                      Text("Возврат", style: AppTextStyles.boldType14),
                      ReceiptText(
                        titleZ: context.tr('refunds_count'),
                        infoZ:
                            state.zReport?.totalRefundCount.toString() ?? "0",
                      ),
                      ReceiptText(
                        titleZ: context.tr('cash'),
                        infoZ: FormatterService().formatNumber(
                            ((state.zReport?.totalRefundCash ?? 0) / 100)
                                .toString()),
                      ),
                      ReceiptText(
                        titleZ: context.tr('card_payment'),
                        infoZ: FormatterService().formatNumber(
                            ((state.zReport?.totalRefundCard ?? 0) / 100)
                                .toString()),
                      ),
                      ReceiptText(
                        titleZ: context.tr('vat'),
                        infoZ: FormatterService().formatNumber(
                            ((state.zReport?.totalRefundVAT ?? 0) / 100)
                                .toString()),
                      ),
                      Text("Итог", style: AppTextStyles.boldType14),
                      ReceiptText(
                        titleZ: context.tr('cash'),
                        infoZ: FormatterService().formatNumber(
                            (((state.zReport?.totalSaleCash ?? 0) -
                                        (state.zReport?.totalRefundCash ?? 0)) /
                                    100)
                                .toString()),
                      ),
                      ReceiptText(
                        titleZ: context.tr('card_payment'),
                        infoZ: FormatterService().formatNumber(
                            (((state.zReport?.totalSaleCard ?? 0) -
                                        (state.zReport?.totalRefundCard ?? 0)) /
                                    100)
                                .toString()),
                      ),
                      ReceiptText(
                        titleZ: context.tr('vat'),
                        infoZ: FormatterService().formatNumber(
                            (((state.zReport?.totalSaleVAT ?? 0) -
                                        (state.zReport?.totalRefundVAT ?? 0)) /
                                    100)
                                .toString()),
                      ),
                      Divider(
                          endIndent: 8,
                          indent: 8,
                          thickness: 1,
                          color: Colors.grey[500]),
                      ReceiptText(
                        titleZ: context.tr("cash_outed"),
                        infoZ: FormatterService().formatNumber(
                            ((state.cashOutSum ?? 0) / 100).toString()),
                      ),
                      ReceiptText(
                        titleZ: context.tr("cash_ined"),
                        infoZ: FormatterService().formatNumber(
                            ((state.cashInSum ?? 0) / 100).toString()),
                      ),
                      Divider(
                          endIndent: 8,
                          indent: 8,
                          thickness: 1,
                          color: Colors.grey[500]),
                      ReceiptText(
                        titleZ: context.tr('module_gnk_id'),
                        infoZ: state.zReport?.terminalID ?? "",
                      ),
                    ])),
                Container(
                    width: 400,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ClipPath(
                        clipper: BottomZigzagClipper(),
                        child: Container(color: Colors.white, height: 10))),
                Container(
                  width: 400,
                  height: 45,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final bloc = context.read<ShiftCubit>();
                      /*showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            // Позволяет ловить клики за пределами диалога
                            onTap: () => Navigator.of(context).pop(),
                            // Закрываем диалог при нажатии вне
                            child: Align(
                              alignment: Alignment.topCenter,
                              // Размещаем диалог выше
                              child: Padding(
                                padding: EdgeInsets.only(top: 50),
                                // Отступ сверху
                                child: GestureDetector(
                                  onTap: () {},
                                  child: CashInOut(type: 'cash_out'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ).then((value) {
                        bloc.closeShift();
                      });*/
                      bloc.closeShift();
                    },
                    child: Text(context.tr("close_shift_action").toUpperCase(),
                        style: AppTextStyles.boldType16),
                  ),
                )
              ])
            ]);
          } else if (state.status == StateStatus.loaded && !state.isOpen) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                  Icon(Icons.lock, size: 80, color: AppColors.secondary500),
                  Text(
                      "Смена закрыта. Перед продажей, пожалуйста, откройте смену!",
                      style: AppTextStyles.boldType14),
                  Container(
                    width: 400,
                    height: 45,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final bloc = context.read<ShiftCubit>();
                        /*showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              // Позволяет ловить клики за пределами диалога
                              onTap: () => Navigator.of(context).pop(),
                              // Закрываем диалог при нажатии вне
                              child: Align(
                                alignment: Alignment.topCenter,
                                // Размещаем диалог выше
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  // Отступ сверху
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: CashInOut(type: 'cash_in'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).then((value) {
                          bloc.openShift(context);
                        });*/
                        bloc.openShift(context);
                      },
                      child: Text(context.tr("open_shift_action").toUpperCase(),
                          style: AppTextStyles.boldType16),
                    ),
                  )
                ]));
          }
          return Center(child: Text(state.errorText ?? "Что то пошло не так"));
        }));
  }
}
