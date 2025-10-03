import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/supplies/cubit/supply_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/back_button_widget.dart';

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
import '../../../search/cubit/search_bloc.dart';
import '../../../supplier/children/cubit/supplier_cubit.dart';
import '../../widgets/delete_product_widget.dart';
import '../../widgets/title_supplies.dart';
import 'widgets/supply_item_widget.dart';

@RoutePage()
class SuppliesScreen extends HookWidget implements AutoRouteWrapper {
  const SuppliesScreen(
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
    useEffect(() {
      context
        ..supplierBloc.getSuppliers()
        ..supplyBloc.searchSupplies(stock.id, true);
      return null;
    }, const []);
    final fromController = useTextEditingController();
    final toController = useTextEditingController();
    final supplierController = useTextEditingController();

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
                    child: Container(
                      padding: AppUtils.kPaddingAll12,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary100.opcty(.3),
                        borderRadius: AppUtils.kBorderRadius12,
                      ),
                      child: Text(
                        "Поступление товаров в склад : ${stock.name}",
                        style: const TextStyle(fontSize: 13),
                        maxLines: 1,
                      ),
                    ),
                  ),

                  ///
                  AppUtils.kGap6,
                  BlocBuilder<SupplierCubit, SupplierState>(
                    builder: (context, state) => Container(
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: AppUtils.kBorderRadius12,
                      ),
                      child: DropdownMenu<int?>(
                        width: 220,
                        hintText: 'Выбор поставщика',
                        textStyle: const TextStyle(fontSize: 11),
                        controller: supplierController,
                        onSelected: (value) => context
                          ..searchBloc.add(SelectSupplier(id: value))
                          ..supplyBloc.selectedSupplier(value),
                        inputDecorationTheme: InputDecorationTheme(
                          hintStyle: const TextStyle(fontSize: 11),
                          isDense: true,
                          constraints: BoxConstraints.tight(const Size.fromHeight(48)),
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
                  BlocBuilder<SupplyCubit, SupplyState>(
                    builder: (context, state) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                    context.supplyBloc.dateFrom(picked);
                                    fromController.text = DateFormat("dd.MM.yyyy").format(picked);
                                  }
                                },
                                child: AbsorbPointer(
                                  child: AppTextField(
                                    width: 150,
                                    label: "От: ",
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
                                    context.supplyBloc.dateTo(picked);
                                    toController.text = DateFormat("dd.MM.yyyy").format(picked);
                                  }
                                },
                                child: AbsorbPointer(
                                  child: AppTextField(
                                    width: 150,
                                    label: "До: ",
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
                              onTap: () => context.supplyBloc.searchSupplies(stock.id, false),
                              child: Container(
                                height: 48,
                                width: context.width * .10,
                                decoration: BoxDecoration(
                                  color: context.primary,
                                  borderRadius: AppUtils.kBorderRadius12,
                                ),
                                child: Center(
                                  child: Text(
                                    "Сформировать",
                                    maxLines: 1,
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
                    onTap: () async => router.push(AddSuppliesRoute(
                      supplyBloc: context.supplyBloc,
                      stock: stock,
                      organization: organization,
                    )),
                    child: Container(
                      height: 48,
                      decoration: const BoxDecoration(
                        borderRadius: AppUtils.kBorderRadius12,
                        color: AppColors.primary800,
                      ),
                      width: context.width * .1,
                      child: Center(
                        child: Text(
                          "Добавить",
                          maxLines: 2,
                          style: TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            ///
            AppUtils.kGap12,
            Expanded(
              child: CustomBox(
                padding: AppUtils.kPaddingAll12.withB0,
                child: Column(
                  children: [
                    const TitleSupplies(isSupplies: true),

                    ///
                    BlocBuilder<SupplyCubit, SupplyState>(
                      buildWhen: (p, c) => p.supplies != c.supplies,
                      builder: (context, state) => Expanded(
                        child: state.status.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : (state.supplies?.results ?? []).isEmpty
                                ? Center(child: Text(context.tr(Dictionary.not_found)))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    itemCount: state.supplies!.results.length,
                                    separatorBuilder: (_, __) => AppUtils.kGap12,
                                    itemBuilder: (_, index) => SupplyItemWidget(
                                      organization: organization,
                                      stock: stock,
                                      admission: state.supplies!.results[index],
                                      onDelete: () async {
                                        final res = await context.showCustomDialog(const DeleteProductWidget());
                                        if (res == null) return;
                                        await context.supplyBloc.deleteSupply(state.supplies!.results[index].id);
                                      },
                                    ),
                                  ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<SupplyCubit>(),
        child: this,
      );
}
