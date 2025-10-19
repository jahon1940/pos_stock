import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../app/router.dart';
import '../../../../../../../../../app/router.gr.dart';
import '../../../../../../../../../core/constants/spaces.dart';
import '../../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../core/widgets/product_table_title.dart';
import '../../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../../data/dtos/inventories/inventory_product_request.dart';
import '../../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../core/constants/dictionary.dart';
import '../../../../../dialogs/search/cubit/fast_search_bloc.dart';
import '../../../../../dialogs/search/search_dialog.dart';
import '../cubit/inventory_cubit.dart';
import 'inventory_product_list.dart';

class AddInventoryProducts extends HookWidget {
  const AddInventoryProducts(
    this.organization,
    this.stock, {
    super.key,
  });

  final CompanyDto organization;
  final StockDto? stock;

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<InventoryCubit, InventoryState>(
        buildWhen: (p, c) => p.request != c.request || p.products != c.products,
        builder: (context, state) => CustomBox(
          child: Padding(
            padding: AppUtils.kPaddingAll12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.inventory != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Инвентаризация товаров в склада: ${stock?.name ?? ''}',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () => context.inventoryBloc.downloadInventory(state.inventory!.id),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
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
                                      'Скачать документ',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Наменклатура', style: AppTextStyles.boldType14),
                          GestureDetector(
                            onTap: () async {
                              final res = await showDialog(
                                context: context,
                                builder: (context) => BlocProvider(
                                  create: (context) => getIt<FastSearchBloc>()..add(SearchInit(false)),
                                  child: SearchDialog(
                                    isDialog: true,
                                    stockId: stock!.id,
                                  ),
                                ),
                              );
                              if (res == null) return;
                              if (res == true) {
                                final data = await router.push(CreateProductRoute()) as String?;
                                if (data == null) return;
                                context.inventoryBloc.addProductByBarcode(data);
                                return;
                              }
                              context.inventoryBloc.addProduct(res);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                              height: 50,
                              width: context.width * .14,
                              child: Center(
                                child: Text(
                                  'Добавить Наменклатуру',
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
                      0: const FlexColumnWidth(5),
                      1: const FlexColumnWidth(2),
                      if (state.products != null) 2: const FlexColumnWidth(3),
                      if (state.products != null) 3: const FlexColumnWidth(2),
                      if (state.products == null) 4: const FlexColumnWidth(2),
                    },
                    titles: [
                      '${context.tr("name")}/${context.tr("article")}',
                      context.tr('count_short'),
                      if (state.products != null) 'Реальное кол-во',
                      if (state.products != null) 'Разница',
                      if (state.products == null) 'Действия',
                    ],
                  ),
                ),

                ///
                AppUtils.kGap12,
                Expanded(
                  child: (state.products ?? []).isEmpty && (state.request?.products ?? []).isEmpty
                      ? Center(child: Text(context.tr(Dictionary.not_found)))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.products?.length ?? state.request?.products.length ?? 0,
                          separatorBuilder: (_, __) => AppSpace.vertical6,
                          itemBuilder: (_, index) => AddInventoryProductList(
                              editable: state.products == null,
                              product: state.products != null
                                  ? InventoryProductRequest(
                                      title: state.products![index].product?.title,
                                      productId: state.products![index].id,
                                      realQuantity: state.products?[index].realQuantity ?? 0,
                                      oldQuantity: state.products?[index].oldQuantity ?? 0,
                                      price: state.products?[index].price,
                                      priceDiff: state.products?[index].priceDiff ?? 0,
                                      quantityDiff: state.products?[index].quantityDiff ?? 0,
                                    )
                                  : state.request?.products[index]),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
}
