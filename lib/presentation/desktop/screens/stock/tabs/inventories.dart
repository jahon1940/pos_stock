import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import '../../../../../app/router.gr.dart';
import '../../../../../core/constants/spaces.dart';
import '../../../../../core/enums/states.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/custom_box.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../../../../data/dtos/company_dto.dart';
import '../../../../../data/dtos/stock_dto.dart';
import '../../../dialogs/inventories_product/inventories_product.dart';
import '../widgets/list_inventories.dart';
import '../widgets/title_supplies.dart';

class Inventories extends HookWidget {
  const Inventories(
    this.stock,
    this.organization, {
    super.key,
  });

  final StockDto stock;
  final CompanyDto organization;
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context
          .read<StockBloc>()
          .add(StockEvent.searchInventories(stock.id, true));
      return null;
    }, const []);
    ThemeData themeData = Theme.of(context);
    final bloc = context.read<StockBloc>();
    final fromController = useTextEditingController();
    final toController = useTextEditingController();
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
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Text(
                          "Инвентаризация товаров в складе : ${stock.name}",
                        ),
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  BlocBuilder<StockBloc, StockState>(builder: (context, state) {
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
                                    bloc.add(StockEvent.dateFrom(picked));

                                    fromController.text =
                                        DateFormat("dd.MM.yyyy").format(picked);
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
                                    bloc.add(StockEvent.dateTo(picked));
                                    toController.text =
                                        DateFormat("dd.MM.yyyy").format(picked);
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
                            AppSpace.horizontal24,
                            GestureDetector(
                              onTap: () async {
                                context.read<StockBloc>().add(
                                    StockEvent.searchInventories(
                                        stock.id, false));
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
                          ],
                        ),
                      ],
                    );
                  }),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: () async {
                      final res = await context
                          .showCustomDialog(InventoriesProductDialog(stock));

                      if (res == null) return;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary500),
                      height: 50,
                      width: context.width * .12,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              color: AppColors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Скачать номенклатуру",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11, color: context.onPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: () async {
                      router.push(AddInventoryRoute(
                          stock: stock, organization: organization));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
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
                  TitleSupplies(
                    isSupplies: false,
                  ),
                  BlocBuilder<StockBloc, StockState>(
                    buildWhen: (previous, current) =>
                        previous.inventories != current.inventories,
                    builder: (context, state) {
                      if (state.status == StateStatus.loading) {
                        return Expanded(
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else if (state.status == StateStatus.loaded) {
                        return Expanded(
                          child: state.inventories?.results == []
                              ? SizedBox()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  itemBuilder: (context, index) =>
                                      state.inventories?.results == []
                                          ? SizedBox()
                                          : InventoryList(
                                              admission: state
                                                  .inventories!.results[index],
                                              onDelete: () async {
                                                // final bloc = context.read<StockBloc>();
                                                // final res = await context.showCustomDialog(
                                                //   DeleteProductWidget(),
                                                // );
                                                //
                                                // if (res == null) return;
                                                //
                                                // bloc.add(StockEvent.deleteSupply(
                                                //     state.supplies[index].id));
                                              },
                                              stock: stock,
                                              organization: organization,
                                            ),
                                  separatorBuilder: (context, index) =>
                                      AppSpace.vertical12,
                                  itemCount:
                                      state.inventories?.results.length ?? 0,
                                ),
                        );
                      }
                      return Center(child: Text("Ошибка загрузки"));
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
