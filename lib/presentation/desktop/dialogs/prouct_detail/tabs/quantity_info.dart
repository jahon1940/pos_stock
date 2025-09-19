import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../../core/constants/spaces.dart';
import '../../../../../core/enums/states.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/text_style.dart';
import '../../../../../core/widgets/product_table_item.dart';
import '../../../../../core/widgets/product_table_title.dart';
import '../../../../../data/dtos/product_dto.dart';
import '../../../../../data/dtos/stock_detail_dto.dart';
import '../cubit/product_detail_cubit.dart';

class QuantityInfo extends HookWidget {
  const QuantityInfo(
    this.productDto, {
    super.key,
  });

  final ProductDto productDto;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    ThemeData themeData = Theme.of(context);
    final scrollController = useScrollController();

    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
      if (state.status == StateStatus.loading) {
        return Center(child: CircularProgressIndicator());
      } else if (state.status == StateStatus.loaded) {
        return Column(
          children: [
            TableTitleProducts(
              fillColor: AppColors.stroke,
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
              },
              titles: [
                context.tr("address"),
                context.tr("phone_number"),
                context.tr("quantity"),
              ],
            ),
            if (state.productDetail?.stocks?.isEmpty ?? true)
              Center(child: Text("Нет в наличии")),
            if (state.productDetail?.stocks?.isNotEmpty ?? false)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  controller: scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    final StockDetailDto stockDetail =
                        state.productDetail!.stocks![index];
                    return TableProductItem(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                      },
                      onTap: () {},
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(stockDetail.stock.name),
                              Text(stockDetail.stock.address ??
                                  context.tr("not_specified")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                              stockDetail.stock.phoneNumber ??
                                  context.tr("not_specified"),
                              textAlign: TextAlign.center),
                        ),
                        SizedBox(
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ост./Резерв: ${stockDetail.quantity}/${stockDetail.quantityReserve}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  Text(
                                    stockDetail.freeQuantity == 0
                                        ? 'Нет в наличии'
                                        : "Своб. ост : ${stockDetail.freeQuantity}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: stockDetail.freeQuantity == 0
                                            ? AppColors.error500
                                            : AppColors.success600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => AppSpace.vertical12,
                  itemCount: state.productDetail?.stocks?.length ?? 0,
                ),
              )
          ],
        );
      }
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ошибка загрузки"),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.success500,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () {
                    context.read<ProductDetailCubit>().search(productDto.id);
                  },
                  child: Text(
                    "Обновить",
                    style: AppTextStyles.boldType16
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
    });
  }
}
