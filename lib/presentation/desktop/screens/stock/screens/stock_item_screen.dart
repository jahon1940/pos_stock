import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/page_title_widget.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../../../../../core/constants/app_utils.dart';
import '../../../../../../core/widgets/custom_box.dart';
import '../../../../../../data/dtos/stock_dto.dart';
import '../../search/cubit/search_bloc.dart';
import '../dialogs/currency/currency_dialog.dart';
import 'category/categories_screen.dart';
import 'inventories/inventories_screen.dart';
import 'stock_products/stock_products_screen.dart';
import 'supplies/supplies_screen.dart';
import 'transfer/transfers_screen.dart';
import 'write_off/write_offs_screen.dart';

@RoutePage()
class StockItemScreen extends StatefulWidget {
  const StockItemScreen({
    required this.stock,
    required this.organization,
    super.key,
  });

  final StockDto stock;
  final CompanyDto organization;

  @override
  State<StockItemScreen> createState() => _StockItemScreenState();
}

class _StockItemScreenState extends State<StockItemScreen> {
  StockDto get stock => widget.stock;

  CompanyDto get organization => widget.organization;
  late final TabbedViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabbedViewController([]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _addTab(
    String title, [
    Widget? content,
  ]) {
    if (_controller.tabs.isNotEmpty) {
      for (var e in _controller.tabs) {
        if (e.text == title) {
          _controller.selectTab(e);
          setState(() {});
          return;
        }
      }
    }
    _controller.addTab(
      TabData(
        text: title,
        content: content ?? Center(child: Text(title)),
        keepAlive: true,
      ),
    );
    _controller.selectTab(_controller.tabs.last);
    setState(() {});
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        body: Padding(
          padding: AppUtils.kPaddingAll10,
          child: Column(
            children: [
              /// title
              PageTitleWidget(
                label: widget.stock.name,
                canPop: true,
              ),

              /// items
              AppUtils.kGap12,
              Expanded(
                child: Row(
                  spacing: AppUtils.mainSpacing,
                  children: [
                    ///
                    CustomBox(
                      padding: AppUtils.kPaddingAll12,
                      child: SizedBox(
                        width: 220,
                        child: Column(
                          spacing: AppUtils.kGap12.mainAxisExtent,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///
                            _item(
                              context,
                              label: 'Поступление товаров',
                              onPressed: () => _addTab('Поступление', SuppliesScreen(stock, organization)),
                              // onPressed: () => router.push(SuppliesRoute(
                              //   stock: stock,
                              //   organization: organization,
                              // )),
                            ),

                            ///
                            _item(
                              context,
                              label: 'Перемещение товаров',
                              onPressed: () => _addTab('Перемещение', TransfersScreen(stock, organization)),
                              // onPressed: () => router.push(TransfersRoute(
                              //   stock: stock,
                              //   organization: organization,
                              // )),
                            ),

                            ///
                            _item(
                              context,
                              label: 'Списание товаров',
                              onPressed: () => _addTab('Списание', WriteOffsScreen(stock, organization)),
                              // onPressed: () => router.push(WriteOffsRoute(
                              //   stock: stock,
                              //   organization: organization,
                              // )),
                            ),

                            ///
                            _item(
                              context,
                              label: 'Инвентаризация',
                              onPressed: () => _addTab('Инвентаризация', InventoriesScreen(stock, organization)),
                              // onPressed: () => router.push(InventoriesRoute(
                              //   stock: stock,
                              //   organization: organization,
                              // )),
                            ),

                            ///
                            _item(
                              context,
                              label: context.tr('sidebar.catalog'),
                              onPressed: () => _addTab(
                                context.tr('sidebar.catalog'),
                                StockProductsScreen(stock, organization),
                              ),
                              // onPressed: () => router.push(StockProductsRoute(
                              //   stock: stock,
                              //   organization: organization,
                              // )),
                            ),

                            ///
                            _item(
                              context,
                              label: 'Категории',
                              onPressed: () => _addTab('Категории', const CategoriesScreen()),
                              // onPressed: () => router.push(const CategoriesRoute()),
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

                    /// tabbed view
                    Expanded(
                      child: TabbedViewTheme(
                        data: TabbedViewThemeData.classic(tabRadius: 12),
                        child: TabbedView(
                          controller: _controller,
                          tabReorderEnabled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          // width: context.width * .3,
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
