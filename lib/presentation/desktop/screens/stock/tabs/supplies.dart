import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/stock_products.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/list_supplies.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/title_supplies.dart';
import '../../../../../app/router.gr.dart';
import '../../../../../core/constants/spaces.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/widgets/custom_box.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../../../../data/dtos/company/company_dto.dart';
import '../../search/cubit/search_bloc.dart';
import '../screens/supplier/cubit/supplier_cubit.dart';

class Supplies extends HookWidget {
  const Supplies(
    this.stock,
    this.organization, {
    super.key,
  });

  final StockDto stock;
  final CompanyDto organization;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.supplierBloc.getSuppliers();
      context.read<StockBloc>().add(StockEvent.searchSupplies(stock.id, true));
      return null;
    }, const []);

    ThemeData themeData = Theme.of(context);
    final bloc = context.read<StockBloc>();
    final fromController = useTextEditingController();
    final toController = useTextEditingController();
    final supplierController = useTextEditingController();
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeData.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.opcty(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(11),
                        child: Text(
                          "Поступление товаров в склад : ${stock.name}",
                        ),
                      ),
                    ),
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
                            textStyle: const TextStyle(fontSize: 11),
                            controller: supplierController,
                            onSelected: (value) {
                              context.read<SearchBloc>().add(
                                    SelectSupplier(id: value),
                                  );
                              context.read<StockBloc>().add(StockEvent.selectedSupplier(value));
                            },
                            inputDecorationTheme: InputDecorationTheme(
                              hintStyle: const TextStyle(fontSize: 11),
                              isDense: true,
                              constraints: BoxConstraints.tight(const Size.fromHeight(35)),
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
                      );
                    },
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

                                    fromController.text = DateFormat("dd.MM.yyyy").format(picked);
                                  }
                                },
                                child: AbsorbPointer(
                                  child: AppTextField(
                                    width: 150,
                                    label: "От: ",
                                    labelStyle:
                                        const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w300),
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
                                    toController.text = DateFormat("dd.MM.yyyy").format(picked);
                                  }
                                },
                                child: AbsorbPointer(
                                  child: AppTextField(
                                    width: 150,
                                    label: "До: ",
                                    labelStyle:
                                        const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w300),
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
                                context.read<StockBloc>().add(StockEvent.searchSupplies(stock.id, false));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                                height: 50,
                                width: context.width * .10,
                                child: Center(
                                  child: Text(
                                    "Сформировать",
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 13, color: context.onPrimary),
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
                    onTap: () async => router.push(AddSuppliesRoute(
                      stock: stock,
                      organization: organization,
                    )),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.primary800),
                      height: 50,
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
          ),
          AppSpace.vertical12,
          Expanded(
            child: CustomBox(
              child: Column(
                children: [
                  const TitleSupplies(
                    isSupplies: true,
                  ),
                  BlocBuilder<StockBloc, StockState>(
                    buildWhen: (previous, current) => previous.supplies != current.supplies,
                    builder: (context, state) {
                      if (state.status == StateStatus.loading) {
                        return const Expanded(child: Center(child: CircularProgressIndicator()));
                      } else if (state.status == StateStatus.loaded) {
                        return Expanded(
                          child: state.supplies?.results == []
                              ? const SizedBox()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  itemBuilder: (context, index) => state.inventories?.results == []
                                      ? const SizedBox()
                                      : SuppliesList(
                                          organization: organization,
                                          stock: stock,
                                          admission: state.supplies!.results[index],
                                          onDelete: () async {
                                            final bloc = context.read<StockBloc>();
                                            final res = await context.showCustomDialog(
                                              const DeleteProductWidget(),
                                            );

                                            if (res == null) return;

                                            bloc.add(StockEvent.deleteSupply(state.supplies!.results[index].id));
                                          },
                                        ),
                                  separatorBuilder: (context, index) => AppSpace.vertical12,
                                  itemCount: state.supplies!.results.length,
                                ),
                        );
                      }
                      return const Center(child: Text("Ошибка загрузки"));
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
