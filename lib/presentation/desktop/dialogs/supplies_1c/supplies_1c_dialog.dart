import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/supplies_1c.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/supplies_1c/cubit/supplies_1c_cubit.dart';

import '../../../../app/router.dart';
import '../../../../app/router.gr.dart';
import '../../../../data/dtos/supplies/supply_product_dto.dart';

class Supplies1CDialog extends HookWidget {
  const Supplies1CDialog(
      {super.key, required this.supply, this.fromCart = false});

  final Supplies1C supply;
  final bool fromCart;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final bloc = context.read<Supplies1cCubit>();
      bloc.getProducts(supply.id!);
      return null;
    }, const []);

    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 15, 80, 15),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: context.width * 0.82,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<Supplies1cCubit, Supplies1cState>(
                builder: (context, state) {
                  if (state.status == StateStatus.error) {
                    return const Center(child: Text("Ошибка загрузки"));
                  } else if (state.status == StateStatus.loaded) {
                    return Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                    "Номер документа: ${supply.number}\nНаименование склада: ${supply.stock?.name}" ??
                                        "",
                                    style: AppTextStyles.boldType14),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<Supplies1cCubit>()
                                      .conduct(supply);
                                  router.push(Supplies1CRoute());
                                },
                                child: Container(
                                  height: 45,
                                  width: context.width * .14,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: context.theme.dividerColor),
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.primary500),
                                  child: Center(
                                    child: Text(
                                      "Провести документ",
                                      style: AppTextStyles.mType12.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              AppSpace.horizontal24,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  context.theme.dividerColor),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppColors.error200
                                              .withOpacity(0.5)),
                                      child: Center(
                                        child: Icon(Icons.close,
                                            color: AppColors.error600),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      TableTitleProducts(
                        fillColor: AppColors.stroke,
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                        },
                        titles: [
                          '${context.tr("name")}/${context.tr("article")}',
                          context.tr("name_uz"),
                          (context.tr("count_short")),
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          itemBuilder: (context, index) {
                            SupplyProductDto products = state.products![index];
                            return Material(
                              child: TableProductItem(
                                columnWidths: const {
                                  0: FlexColumnWidth(4),
                                  1: FlexColumnWidth(3),
                                  2: FlexColumnWidth(2),
                                },
                                onTap: () async {},
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "артикул: ${products.product?.vendorCode ?? " "}",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            products.product?.title ?? "",
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 0),
                                        child: Text(
                                          products.product?.titleUz ?? "",
                                          // contract.name,
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 0),
                                        child: Text(
                                          "${products.quantity} ",
                                          // contract.name,
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              AppSpace.vertical12,
                          itemCount: state.products?.length ?? 0,
                        ),
                      ),
                    ]);
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
