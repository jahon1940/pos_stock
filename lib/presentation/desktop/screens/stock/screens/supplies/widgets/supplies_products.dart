import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_request.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/search/cubit/fast_search_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/search/search_dialog.dart';
import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../cubit/supply_cubit.dart';
import 'supplies_product_list.dart';

class SuppliesProducts extends HookWidget {
  const SuppliesProducts({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<SupplyCubit, SupplyState>(
        buildWhen: (p, c) => p.suppliers != c.suppliers || p.request != c.request || p.products != c.products,
        builder: (context, state) => CustomBox(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.supply != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Поставщик: ${state.supply!.supplier?.name}',
                            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () => context.supplyBloc.downloadSupplies(state.supply!.id),
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
                        children: [
                          DropdownMenu<int>(
                            width: 400,
                            hintText: 'Выберите поставщика',
                            onSelected: (value) => context.supplyBloc.selectSupplier(value ?? 1),
                            dropdownMenuEntries: state.suppliers
                                .map(
                                  (e) => DropdownMenuEntry(
                                    value: e.id,
                                    label: e.name ?? e.inn ?? e.phoneNumber ?? '',
                                  ),
                                )
                                .toList(),
                          ),
                          AppSpace.horizontal24,
                          if (state.suppliers.isEmpty && state.status != StateStatus.loading)
                            GestureDetector(
                              onTap: () => context.supplyBloc.getSuppliers(),
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                                height: 50,
                                width: context.width * .1,
                                child: Center(
                                  child: Text(
                                    'Обновить',
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 13, color: context.onPrimary),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                AppSpace.vertical24,
                if (state.supply == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Наменклатура', style: AppTextStyles.boldType14),
                      GestureDetector(
                        onTap: () async {
                          final res = await showDialog(
                            context: context,
                            builder: (context) => BlocProvider(
                              create: (context) => getIt<FastSearchBloc>()..add(SearchInit(false)),
                              child: const SearchDialog(isDialog: true, isReserve: false),
                            ),
                          );
                          if (res == null) return;
                          if (res == true) {
                            final data = await router.push(AddProductRoute()) as String?;
                            if (data == null) return;
                            context.supplyBloc.addProductByBarcode(data);
                            return;
                          }
                          context.supplyBloc.addProduct(res);
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
                      0: const FlexColumnWidth(4),
                      1: const FlexColumnWidth(2),
                      2: const FlexColumnWidth(2),
                      3: const FlexColumnWidth(2),
                      if (state.products == null) 4: const FlexColumnWidth(),
                    },
                    titles: [
                      '${context.tr("name")}/${context.tr("article")}',
                      context.tr('count_short'),
                      context.tr('priceFrom'),
                      context.tr('priceTo'),
                      if (state.products == null) 'Действия',
                    ],
                  ),
                ),

                ///
                AppSpace.vertical12,
                SizedBox(
                  height: context.height - 390,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.products?.length ?? state.request?.products.length ?? 0,
                    separatorBuilder: (context, index) => AppSpace.vertical6,
                    itemBuilder: (context, index) => SuppliesProductList(
                        editable: state.products == null,
                        product: state.products != null
                            ? SupplyProductRequest(
                                title: state.products![index].product?.title,
                                productId: state.products![index].id,
                                quantity: state.products?[index].quantity ?? 0,
                                purchasePrice: state.products![index].purchasePrice.toString(),
                                price: state.products![index].price.toString())
                            : state.request?.products[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
