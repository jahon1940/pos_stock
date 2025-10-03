import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/search/cubit/fast_search_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/search/search_dialog.dart';
import '../../../../../../../../../core/enums/states.dart';
import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../../../data/dtos/transfers/transfer_product_request.dart';
import '../../../bloc/stock_bloc.dart';
import '../cubit/transfer_cubit.dart';
import 'transfer_product_list.dart';

class TransferProducts extends HookWidget {
  const TransferProducts(
    this.stock,
    this.organization, {
    super.key,
  });

  final CompanyDto organization;
  final StockDto? stock;

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<TransferCubit, TransferState>(
        builder: (context, state) => CustomBox(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.transfer != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Склад перемещение: ${state.transfer!.toStock?.name}',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () => context.stockBloc.add(StockEvent.downloadTransfers(state.transfer!.id)),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: context.primary,
                              ),
                              height: 50,
                              width: context.width * .14,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_copy_outlined,
                                      color: context.onPrimary,
                                    ),
                                    AppSpace.horizontal12,
                                    Text(
                                      "Скачать документ",
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 13, color: context.onPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          DropdownMenu<int>(
                            width: 400,
                            hintText: 'Выберите Склад',
                            onSelected: (value) => context.transferBloc.selectStock(
                              fromStockId: stock!.id,
                              toStockId: value ?? 1,
                            ),
                            dropdownMenuEntries: state.stocks
                                .map(
                                  (e) => DropdownMenuEntry(
                                    value: stock?.id != e.id ? e.id : 0,
                                    label: stock?.name != e.name ? e.name : '',
                                  ),
                                )
                                .toList(),
                          ),
                          AppSpace.horizontal24,
                          if (state.stocks.isEmpty && state.status != StateStatus.loading)
                            GestureDetector(
                              onTap: () => context.transferBloc.getStocks(organization.id),
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                                height: 50,
                                width: context.width * .1,
                                child: Center(
                                  child: Text(
                                    "Обновить",
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 13, color: context.onPrimary),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                AppSpace.vertical24,
                if (state.transfer == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Наменклатура',
                        style: AppTextStyles.boldType14,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final res = await showDialog(
                            context: context,
                            builder: (context) => BlocProvider(
                              create: (context) => getIt<FastSearchBloc>()..add(SearchInit(false)),
                              child: SearchDialog(
                                isDialog: true,
                                isReserve: false,
                                stockId: stock!.id,
                              ),
                            ),
                          );
                          if (res == null) return;
                          if (res == true) {
                            final data = await router.push(AddProductRoute()) as String?;
                            if (data == null) return;
                            context.transferBloc.addProductByBarcode(data);
                            return;
                          }
                          context.transferBloc.addProduct(res);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                          height: 50,
                          width: context.width * .14,
                          child: Center(
                            child: Text(
                              "Добавить Наменклатуру",
                              maxLines: 2,
                              style: TextStyle(fontSize: 13, color: context.onPrimary),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                SizedBox(
                  height: 40,
                  child: TableTitleProducts(
                    fillColor: AppColors.stroke,
                    columnWidths: {
                      0: const FlexColumnWidth(6),
                      1: const FlexColumnWidth(2),
                      2: const FlexColumnWidth(),
                      if (state.products == null) 4: const FlexColumnWidth(),
                    },
                    titles: [
                      '${context.tr("name")}/${context.tr("article")}',
                      context.tr("count_short"),
                      if (state.products == null) "Действия",
                    ],
                  ),
                ),
                AppSpace.vertical12,
                SizedBox(
                  height: context.height - 390,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.products?.length ?? state.request?.products?.length ?? 0,
                    separatorBuilder: (context, index) => AppSpace.vertical6,
                    itemBuilder: (context, index) => TransferProductList(
                        editable: state.products == null,
                        product: state.products != null
                            ? TransferProductRequest(
                                title: state.products![index].product?.title,
                                productId: state.products![index].id,
                                quantity: state.products?[index].quantity ?? 0,
                              )
                            : state.request?.products?[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
