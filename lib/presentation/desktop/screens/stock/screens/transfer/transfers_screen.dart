import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/transfer/cubit/transfer_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/back_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../app/router.dart';
import '../../../../../../../../app/router.gr.dart';
import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/constants/dictionary.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../app/di.dart';
import '../../widgets/title_supplies.dart';
import 'widgets/transfer_item_widget.dart';

class TransfersScreen extends HookWidget {
  const TransfersScreen(
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
    final fromController = useTextEditingController();
    final toController = useTextEditingController();

    return Provider<TransferCubit>(
      create: (_) => getIt<TransferCubit>()..searchTransfers(stock.id, true),
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
                  children: [
                    ///
                    const BackButtonWidget(),

                    ///
                    AppUtils.kGap6,
                    Expanded(
                      child: Container(
                        padding: AppUtils.kPaddingAll12,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary100.opcty(.3),
                          borderRadius: AppUtils.kBorderRadius12,
                        ),
                        child: Text(
                          'Перемещение товаров с склада : ${stock.name}',
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                        ),
                      ),
                    ),

                    ///
                    AppUtils.kGap6,
                    BlocBuilder<TransferCubit, TransferState>(
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
                                      context.transferBloc.dateFrom(picked);
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
                                      context.transferBloc.dateTo(picked);
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
                                onTap: () async => context.transferBloc.searchTransfers(stock.id, false),
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
                      onTap: () async => router.push(AddTransferRoute(
                        transferBloc: blocContext.transferBloc,
                        stock: stock,
                        organization: organization,
                      )),
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
                      const TitleSupplies(isSupplies: false),

                      ///
                      BlocBuilder<TransferCubit, TransferState>(
                        buildWhen: (p, c) => p.transfers != c.transfers,
                        builder: (context, state) => Expanded(
                          child: state.status.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : (state.transfers?.results ?? []).isEmpty
                                  ? Center(child: Text(context.tr(Dictionary.not_found)))
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                      separatorBuilder: (_, __) => AppUtils.kGap12,
                                      itemCount: state.transfers?.results.length ?? 0,
                                      itemBuilder: (context, index) => TransfersItemWidget(
                                        admission: state.transfers!.results[index],
                                        onDelete: () {},
                                        stock: stock,
                                        organization: organization,
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
}
