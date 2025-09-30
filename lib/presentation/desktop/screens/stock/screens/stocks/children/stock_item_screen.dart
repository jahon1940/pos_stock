import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/category/category_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/inventories.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/stock_products.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/page_title_widget.dart';

import '../../../../../../../app/router.dart';
import '../../../../../../../app/router.gr.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../data/dtos/stock_dto.dart';
import '../../../../search/cubit/search_bloc.dart';
import '../../../dialogs/currency/currency_dialog.dart';

@RoutePage()
class StockItemScreen extends HookWidget {
  const StockItemScreen({
    required this.stock,
    required this.organization,
    super.key,
  });

  final StockDto stock;
  final CompanyDto organization;

  @override
  Widget build(
    BuildContext context,
  ) =>
      DefaultTabController(
        length: 2, // todo delete
        child: Scaffold(
          body: Padding(
            padding: AppUtils.kPaddingAll10,
            child: Column(
              children: [
                /// title
                PageTitleWidget(
                  label: stock.name,
                  canPop: true,
                ),

                /// items
                AppUtils.kGap12,
                Expanded(
                  flex: 2,
                  child: CustomBox(
                    padding: AppUtils.kPaddingAll12,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        spacing: AppUtils.kGap12.mainAxisExtent,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///
                          _item(
                            context,
                            label: 'Поступление товаров',
                            onPressed: () => router.push(SuppliesRoute(
                              stock: stock,
                              organization: organization,
                            )),
                          ),

                          ///
                          _item(
                            context,
                            label: "Перемещение товаров",
                            onPressed: () => router.push(TransfersRoute(
                              stock: stock,
                              organization: organization,
                            )),
                          ),

                          ///
                          _item(
                            context,
                            label: 'Списание товаров',
                            onPressed: () => router.push(WriteOffsRoute(
                              stock: stock,
                              organization: organization,
                            )),
                          ),

                          ///
                          _item(
                            context,
                            label: 'Инвентаризация',
                            onPressed: () {},
                          ),

                          ///
                          _item(
                            context,
                            label: context.tr("sidebar.catalog"),
                            onPressed: () {},
                          ),

                          ///
                          _item(
                            context,
                            label: 'Категории',
                            onPressed: () async {
                              final res = await context.showCustomDialog(const CategoryDialog());
                              if (res == null) return;
                              final bloc = context.read<SearchBloc>();
                              bloc.add(SearchRemoteTextChanged(''));
                            },
                          ),

                          ///
                          _item(
                            context,
                            label: 'Установить Курс',
                            onPressed: () async {
                              final bloc = context.read<SearchBloc>();
                              final res = await context.showCustomDialog(const CurrencyDialog());
                              if (res == null) return;
                              bloc.add(SearchRemoteTextChanged(''));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// title
                AppUtils.kGap12,
                Row(
                  children: [
                    SizedBox(
                      width: context.width * .7,
                      child: Center(
                        child: TabBar(
                          labelPadding: EdgeInsets.zero,
                          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: context.primary),
                          tabs: [
                            /// todo
                            FittedBox(
                              child: SizedBox(
                                width: context.width * .15,
                                child: const Tab(
                                  child: Text(
                                    "Инвентаризация",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                            FittedBox(
                              child: SizedBox(
                                width: context.width * .15,
                                child: Tab(
                                  child: Text(
                                    context.tr("sidebar.catalog"),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 15),
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

                /// body
                AppUtils.kGap12,
                Expanded(
                  child: TabBarView(
                    children: [
                      Inventories(stock, organization),
                      StockProducts(stock, organization),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _item(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) =>
      GestureDetector(
        onTap: onPressed,
        child: Container(
          width: context.width * .3,
          height: 50,
          padding: AppUtils.kPaddingHor12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: context.onPrimary),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      );
}
