import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/constants/dictionary.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../app/di.dart';
import '../../../../../../data/dtos/write_offs/write_off_dto.dart';
import '../../widgets/table_title_widget.dart';
import 'add_write_off_screen.dart';
import 'cubit/write_off_cubit.dart';
import 'widgets/write_off_item_widget.dart';

class WriteOffsScreen extends HookWidget {
  const WriteOffsScreen({
    required this.navigationKey,
    required this.stock,
    required this.organization,
    super.key,
  });

  final GlobalKey<NavigatorState> navigationKey;
  final StockDto stock;
  final CompanyDto organization;
  static const _columnWidths = {
    0: FlexColumnWidth(2),
    1: FlexColumnWidth(2),
    2: FlexColumnWidth(2),
    3: FlexColumnWidth(2),
  };

  @override
  Widget build(
    BuildContext context,
  ) {
    final fromController = useTextEditingController();
    final toController = useTextEditingController();
    return Provider<WriteOffCubit>(
      create: (_) => getIt<WriteOffCubit>()..searchWriteOffs(stock.id, true),
      builder: (blocContext, _) => Scaffold(
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const BackButtonWidget(),
                    // AppUtils.kGap6,

                    ///
                    // Expanded(
                    //   child: Container(
                    //     padding: AppUtils.kPaddingAll12,
                    //     alignment: Alignment.center,
                    //     decoration: BoxDecoration(
                    //       color: AppColors.primary100.opcty(.3),
                    //       borderRadius: AppUtils.kBorderRadius12,
                    //     ),
                    //     child: Text(
                    //       'Списание товаров с склада : ${stock.name}',
                    //       style: const TextStyle(fontSize: 13),
                    //       maxLines: 1,
                    //     ),
                    //   ),
                    // ),

                    ///
                    AppUtils.kGap6,
                    BlocBuilder<WriteOffCubit, WriteOffState>(
                      builder: (context, state) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///
                              Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: AppUtils.kBorderRadius12,
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
                                      context.writeOffBloc.dateFrom(picked);
                                      fromController.text = DateFormat('dd.MM.yyyy').format(picked);
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: AppTextField(
                                      width: 150,
                                      label: 'От: ',
                                      labelStyle: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      readOnly: true,
                                      enabledBorderWith: 1,
                                      enabledBorderColor: Colors.transparent,
                                      fieldController: fromController,
                                    ),
                                  ),
                                ),
                              ),

                              ///
                              AppUtils.kGap6,
                              Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: AppUtils.kBorderRadius12,
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
                                      context.writeOffBloc.dateTo(picked);
                                      toController.text = DateFormat('dd.MM.yyyy').format(picked);
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: AppTextField(
                                      width: 150,
                                      label: 'До: ',
                                      labelStyle: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      readOnly: true,
                                      enabledBorderWith: 1,
                                      enabledBorderColor: Colors.transparent,
                                      fieldController: toController,
                                    ),
                                  ),
                                ),
                              ),

                              ///
                              AppUtils.kGap6,
                              GestureDetector(
                                onTap: () async => context.writeOffBloc.searchWriteOffs(stock.id, false),
                                child: Container(
                                  height: 48,
                                  width: context.width * .10,
                                  decoration: BoxDecoration(
                                    color: context.primary,
                                    borderRadius: AppUtils.kBorderRadius12,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Сформировать',
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 13, color: context.onPrimary),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ///
                    AppUtils.kGap6,
                    GestureDetector(
                      onTap: () => _push(blocContext),
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
              AppUtils.kMainObjectsGap,
              Expanded(
                child: CustomBox(
                  child: Column(
                    children: [
                      const TableTitleWidget(
                        columnWidths: _columnWidths,
                        titles: ['Номер', 'Дата создания', 'Продукты', 'Действия'],
                      ),
                      BlocBuilder<WriteOffCubit, WriteOffState>(
                        buildWhen: (p, c) => p.writeOffs != c.writeOffs,
                        builder: (context, state) => Expanded(
                          child: state.status.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : (state.writeOffs?.results ?? []).isEmpty
                                  ? Center(child: Text(context.tr(Dictionary.not_found)))
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                      itemCount: state.writeOffs?.results.length ?? 0,
                                      separatorBuilder: (_, __) => AppUtils.kGap12,
                                      itemBuilder: (context, index) => WriteOffItemWidget(
                                        stock: stock,
                                        organization: organization,
                                        writeOff: state.writeOffs!.results[index],
                                        onTap: () => _push(blocContext, state.writeOffs!.results[index]),
                                      ),
                                    ),
                        ),
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

  void _push(
    BuildContext context, [
    WriteOffDto? writeOff,
  ]) =>
      navigationKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => AddWriteOffScreen(
            writeOffBloc: context.writeOffBloc,
            organization: organization,
            stock: stock,
            writeOff: writeOff,
          ),
        ),
      );
}
