import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_inventory/widgets/inventory_navbar.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_inventory/widgets/inventory_products.dart';
import '../../../../../../app/di.dart';
import '../../../../../../app/router.dart';
import '../../../../../../app/router.gr.dart';
import '../../../../../../core/constants/spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/text_style.dart';
import '../../../../../../core/utils/date_parser.dart';
import '../../../../../../data/dtos/company_dto.dart';
import '../../../../../../data/dtos/inventories/inventory_dto.dart';
import '../../../../../../data/dtos/stock_dto.dart';
import 'cubit/add_inventory_cubit.dart';

@RoutePage()
class AddInventoryScreen extends HookWidget implements AutoRouteWrapper {
  const AddInventoryScreen(
    this.organization,
    this.stock, {
    super.key,
    this.inventory,
  });
  final CompanyDto organization;
  final StockDto? stock;
  final InventoryDto? inventory;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: AppColors.softGrey,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: AppColors.stroke, blurRadius: 3)
                  ],
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: AppColors.stroke, blurRadius: 3)
                            ],
                          ),
                          child: InkWell(
                            onTap: () => router.push(StockRoute(
                                stock: stock!, organization: organization)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 10, 12),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    AppSpace.horizontal12,
                    Text(
                        'Инвентаризация товаров в складе: ${stock?.name ?? ''} ${inventory == null ? '' : 'от ${DateParser.dayMonthHString(inventory?.createdAt, 'ru')}'}',
                        style: AppTextStyles.boldType14
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              AppSpace.vertical12,
              Expanded(child: AddInventoryProducts(organization, stock)),
            ],
          ),
        ),
        bottomNavigationBar: AddInventoryNavbar(stock, organization));
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddInventoryCubit>()..init(inventory),
      child: this,
    );
  }
}
