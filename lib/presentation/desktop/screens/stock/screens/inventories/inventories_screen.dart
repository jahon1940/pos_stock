import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/inventories/cubit/inventory_cubit.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../app/router.dart';
import '../../../../../../../../../app/router.gr.dart';
import '../../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../../core/constants/dictionary.dart';
import '../../../../../../app/di.dart';
import '../../../../dialogs/inventories_product/inventories_product.dart';
import '../../widgets/title_supplies.dart';
import 'widgets/inventory_item_widget.dart';

class InventoriesScreen extends HookWidget {
  const InventoriesScreen(
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
    return Provider<InventoryCubit>(
      create: (context) => getIt<InventoryCubit>()..searchInventories(stock.id, true),
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
                    // const BackButtonWidget(),
                    // AppUtils.kGap6,

                    ///
                    Expanded(
                      child: Container(
                        padding: AppUtils.kPaddingAll12,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary100.opcty(.3),
                          borderRadius: AppUtils.kBorderRadius12,
                        ),
                        child: Text(
                          'Инвентаризация товаров в складе : ${stock.name}',
                          style: const TextStyle(fontSize: 13),
                          maxLines: 1,
                        ),
                      ),
                    ),

                    ///
                    AppUtils.kGap6,
                    BlocBuilder<InventoryCubit, InventoryState>(
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
                                      context.inventoryBloc.dateFrom(picked);
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
                                      context.inventoryBloc.dateTo(picked);
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
                                onTap: () => context.inventoryBloc.searchInventories(stock.id, false),
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
                      onTap: () async => context.showCustomDialog(InventoriesProductDialog(stock)),
                      child: Container(
                        height: 48,
                        width: context.width * .12,
                        decoration: const BoxDecoration(
                          borderRadius: AppUtils.kBorderRadius12,
                          color: AppColors.primary500,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.download,
                              color: AppColors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Скачать номенклатуру',
                              maxLines: 2,
                              style: TextStyle(fontSize: 11, color: context.onPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///
                    AppUtils.kGap6,
                    GestureDetector(
                      onTap: () async => router.push(AddInventoryRoute(
                        inventoryBloc: blocContext.inventoryBloc,
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
                      const TitleSupplies(),

                      ///
                      BlocBuilder<InventoryCubit, InventoryState>(
                        buildWhen: (p, c) => p.inventories != c.inventories,
                        builder: (context, state) => Expanded(
                          child: state.status.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : (state.inventories?.results ?? []).isEmpty
                                  ? Center(child: Text(context.tr(Dictionary.not_found)))
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                      itemCount: state.inventories!.results.length,
                                      separatorBuilder: (_, __) => AppUtils.kGap12,
                                      itemBuilder: (context, index) => InventoryItemWidget(
                                        admission: state.inventories!.results[index],
                                        stock: stock,
                                        organization: organization,
                                        onDelete: () {},
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
