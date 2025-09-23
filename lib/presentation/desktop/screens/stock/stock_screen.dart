import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/category/category_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/inventories.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/transfers.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/supplies.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/stock_products.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/write_off.dart';

import '../../../../core/styles/colors.dart';
import '../../../../data/dtos/stock_dto.dart';
import '../search/cubit/search_bloc.dart';
import 'dialogs/currency/currency_dialog.dart';

enum SampleItem {
  itemOne,
  itemTwo,
}

@RoutePage()
class StockScreen extends HookWidget {
  const StockScreen({
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
    ThemeData themeData = Theme.of(context);
    SampleItem? selectedItem;
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                          ),
                          child: InkWell(
                            onTap: () => router.push(StocksRoute(organizations: organization)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: context.width * .7,
                      child: Center(
                        child: TabBar(
                          labelPadding: EdgeInsets.zero,
                          padding: EdgeInsets.all(8),
                          indicatorPadding: EdgeInsets.zero,
                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: context.primary),
                          tabs: <Widget>[
                            // for (final index in [0, 1, 2])
                            FittedBox(
                              child: SizedBox(
                                width: context.width * .15,
                                child: Tab(
                                  child: Text(
                                    "Поступление товаров",
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
                                child: Tab(
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
                                child: Tab(
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
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: context.primary),
                        width: context.width * .05,
                        height: 50,
                        child: Center(
                          child: PopupMenuButton<SampleItem>(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 25,
                            ),
                            initialValue: selectedItem,
                            onSelected: (SampleItem item) {
                              // setState(() {
                              //   selectedItem = item;
                              // });
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                              PopupMenuItem<SampleItem>(
                                onTap: () async {
                                  final bloc = context.read<SearchBloc>();
                                  final res = await context.showCustomDialog(CategoryDialog());
                                  if (res == null) return;
                                  bloc.add(SearchRemoteTextChanged(''));
                                },
                                value: SampleItem.itemOne,
                                child: Padding(
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
                                  final res = await context.showCustomDialog(CurrencyDialog());
                                  if (res == null) return;
                                  bloc.add(SearchRemoteTextChanged(''));
                                },
                                value: SampleItem.itemTwo,
                                child: Padding(
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
                    )
                  ],
                ),
              ),
              AppSpace.vertical12,
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Supplies(stock, organization),
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
}
