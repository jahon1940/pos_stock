import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/un_sale_products/cubit/un_sale_products_cubit.dart';

import '../../../../core/styles/colors.dart';
import '../../../../core/styles/text_style.dart';

class UnSaleProductsDialog extends HookWidget {
  const UnSaleProductsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    var selectedValue = useState(true);

    useEffect(() {
      context.read<UnSaleProductsCubit>().init(true);
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          context.read<UnSaleProductsCubit>().loadMore(selectedValue.value);
        }
      });
      return null;
    }, const []);

    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 15, 80, 15),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
              width: context.width * 0.8,
              height: context.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<bool>(
                              elevation: 0,
                              borderRadius: BorderRadius.circular(10),
                              focusColor: Colors.transparent,
                              value: selectedValue.value,
                              onChanged: (bool? newValue) {
                                selectedValue.value = newValue ?? false;
                                context
                                    .read<UnSaleProductsCubit>()
                                    .init(newValue ?? false);
                              },
                              items: <bool>[
                                false, // Первый элемент
                                true // Второй элемент
                              ].map<DropdownMenuItem<bool>>((bool value) {
                                return DropdownMenuItem<bool>(
                                  value: value,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Text(
                                      value
                                          ? context.tr("un_sale_products")
                                          : "Ходовые товары",
                                      style: AppTextStyles.boldType12,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            hoverColor: context.theme.hoverColor,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: context.theme.dividerColor),
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.error200.withOpacity(0.5)),
                                child: Icon(Icons.close,
                                    color: AppColors.error600)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child:
                        BlocBuilder<UnSaleProductsCubit, UnSaleProductsState>(
                      builder: (context, state) {
                        if (state.status == StateStatus.initial) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (state.products?.results.isEmpty ?? true) {
                          return const Center(child: Text('Ничего не найдено'));
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TableTitleProducts(
                                fillColor: AppColors.stroke,
                                columnWidths: const {
                                  0: FlexColumnWidth(4),
                                  1: FlexColumnWidth(3),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(2),
                                  4: FlexColumnWidth(2),
                                },
                                titles: [
                                  '${context.tr("name")}/${context.tr("article")}',
                                  context.tr("name_uz"),
                                  "${context.tr("quantity_short")}/${context.tr("reserve")}",
                                  context.tr("price"),
                                  "Кол-во продаж",
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8.0),
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  final product =
                                      state.products!.results[index];

                                  final currencyFormatter =
                                      NumberFormat.currency(
                                    locale: 'ru_RU',
                                    symbol: '',
                                    decimalDigits: 0,
                                  );

                                  return TableProductItem(
                                    columnWidths: const {
                                      0: FlexColumnWidth(4),
                                      1: FlexColumnWidth(3),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(2),
                                      4: FlexColumnWidth(2),
                                    },
                                    onTap: () {},
                                    children: [
                                      SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 5, 5, 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppSpace.vertical2,
                                                    Text(
                                                      "${context.tr("article")}: ${product.vendorCode ?? 'Не найдено'}",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 9),
                                                    ),
                                                    Text(
                                                      product.title ?? '',
                                                      maxLines: 2,
                                                    ),
                                                    AppSpace.vertical2,
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 5, 5, 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AppSpace.vertical2,
                                                    Text(
                                                      "${context.tr("article")}: ${product.vendorCode ?? 'Не найдено'}",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 9),
                                                    ),
                                                    Text(
                                                      product.titleUz ?? '',
                                                      maxLines: 2,
                                                    ),
                                                    AppSpace.vertical2,
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.quantity == 0
                                                      ? 'Нет в наличии'
                                                      : "Ост./Резерв: ${product.quantity ?? product.globalQuantity}/${product.reserveQuantity ?? product.reserve} ${product.measure ?? ''}",
                                                  style: const TextStyle(
                                                      fontSize: 11),
                                                ),
                                                if ((product.freeQuantity ??
                                                        0) >
                                                    0)
                                                  Text(
                                                    product.freeQuantity == 0
                                                        ? 'Нет в наличии'
                                                        : "Своб. ост : ${product.freeQuantity} ${product.measure ?? ""}",
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: AppColors
                                                            .success600),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 5, 10, 5),
                                          child: product.price == null
                                              ? const SizedBox()
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    product.purchasePriceDollar ==
                                                                0 ||
                                                            product.purchasePriceDollar ==
                                                                null
                                                        ? SizedBox()
                                                        : Text(
                                                            "Приходная цена: ${product.purchasePriceDollar} \$",
                                                            style: const TextStyle(
                                                                fontSize: 11,
                                                                color: AppColors
                                                                    .success600),
                                                          ),
                                                    product.priceDollar == 0 ||
                                                            product.priceDollar ==
                                                                null
                                                        ? SizedBox()
                                                        : Text(
                                                            "Цена продажи: ${product.priceDollar} \$",
                                                            style: const TextStyle(
                                                                fontSize: 11,
                                                                color: AppColors
                                                                    .success600),
                                                          ),
                                                    product.priceDollar == 0 ||
                                                            product.priceDollar ==
                                                                null
                                                        ? SizedBox()
                                                        : Divider(),
                                                    Text(
                                                      "${currencyFormatter.format(product.price).replaceAll('.', ' ')} сум",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Text(
                                              "${product.saleCount ?? "0"}",
                                              style: AppTextStyles.boldType12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    AppSpace.vertical12,
                                itemCount: state.products?.results.length ?? 0,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
