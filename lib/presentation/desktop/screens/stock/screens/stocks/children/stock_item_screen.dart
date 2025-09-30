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
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/transfers.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/write_off.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/page_title_widget.dart';

import '../../../../../../../app/router.dart';
import '../../../../../../../app/router.gr.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../data/dtos/stock_dto.dart';
import '../../../../search/cubit/search_bloc.dart';
import '../../../dialogs/currency/currency_dialog.dart';

enum SampleItem {
  itemOne,
  itemTwo,
}

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
  ) {
    SampleItem? selectedItem;
    return DefaultTabController(
      length: 5, // todo delete
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
                          FittedBox(
                            child: SizedBox(
                              width: context.width * .15,
                              child: const Tab(
                                child: Text(
                                  "Перемещение товаров",
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
                              child: const Tab(
                                child: Text(
                                  "Списание товаров",
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

                  /// menu button
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: context.primary),
                    width: context.width * .05,
                    height: 50,
                    child: Center(
                      child: PopupMenuButton<SampleItem>(
                        initialValue: selectedItem,
                        onSelected: (SampleItem item) {},
                        icon: const Icon(Icons.menu, color: Colors.white, size: 25),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<SampleItem>(
                            onTap: () async {
                              final bloc = context.read<SearchBloc>();
                              final res = await context.showCustomDialog(const CategoryDialog());
                              if (res == null) return;
                              bloc.add(SearchRemoteTextChanged(''));
                            },
                            value: SampleItem.itemOne,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                              child: ListTile(
                                leading: Icon(Icons.source_rounded),
                                title: Text('Категории'),
                              ),
                            ),
                          ),
                          PopupMenuItem<SampleItem>(
                            onTap: () async {
                              final bloc = context.read<SearchBloc>();
                              final res = await context.showCustomDialog(const CurrencyDialog());
                              if (res == null) return;
                              bloc.add(SearchRemoteTextChanged(''));
                            },
                            value: SampleItem.itemTwo,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                              child: ListTile(
                                leading: Icon(Icons.currency_exchange),
                                title: Text('Установить Курс'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /// items
              AppUtils.kGap12,
              Expanded(
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
                          label: context.tr("Перемещение товаров"),
                          onPressed: () {},
                        ),

                        ///
                        _item(
                          context,
                          label: 'Списание товаров',
                          onPressed: () {},
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
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// body
              AppUtils.kGap12,
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Transfers(stock, organization),
                    WriteOff(stock, organization),
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
  }

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
