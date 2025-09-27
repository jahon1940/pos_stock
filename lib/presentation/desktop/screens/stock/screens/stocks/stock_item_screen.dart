import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/category/category_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/inventories.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/transfers.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/supplies.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/stock_products.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/tabs/write_off.dart';

import '../../../../../../core/constants/app_utils.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../data/dtos/stock_dto.dart';
import '../../../search/cubit/search_bloc.dart';
import '../../dialogs/currency/currency_dialog.dart';
import '../../widgets/back_button_widget.dart';

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
      length: 5,
      child: Scaffold(
        body: Padding(
          padding: AppUtils.kPaddingAll10,
          child: Column(
            children: [
              /// title
              Container(
                padding: AppUtils.kPaddingAll6,
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// back button
                    const BackButtonWidget(),

                    ///
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
                          tabs: <Widget>[
                            FittedBox(
                              child: SizedBox(
                                width: context.width * .15,
                                child: const Tab(
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
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 25,
                          ),
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
              ),

              /// body
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
