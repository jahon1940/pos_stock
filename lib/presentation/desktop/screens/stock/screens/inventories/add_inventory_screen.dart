import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/inventories/cubit/inventory_cubit.dart';
import '../../../../../../../../core/constants/spaces.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../core/utils/date_parser.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/inventories/inventory_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import 'widgets/inventory_navbar.dart';
import 'widgets/inventory_products.dart';

@RoutePage()
class AddInventoryScreen extends StatelessWidget {
  const AddInventoryScreen(
    this.inventoryBloc,
    this.organization,
    this.stock, {
    super.key,
    this.inventory,
  });

  final InventoryCubit inventoryBloc;
  final CompanyDto organization;
  final StockDto? stock;
  final InventoryDto? inventory;

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider.value(
        value: inventoryBloc..init(inventory),
        child: Scaffold(
            backgroundColor: AppColors.softGrey,
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary500,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                              ),
                              child: InkWell(
                                onTap: () => context.pop(),
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(16, 12, 10, 12),
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
                          style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  AppSpace.vertical12,
                  Expanded(child: AddInventoryProducts(organization, stock)),
                ],
              ),
            ),
            bottomNavigationBar: AddInventoryNavbar(stock, organization)),
      );
}
