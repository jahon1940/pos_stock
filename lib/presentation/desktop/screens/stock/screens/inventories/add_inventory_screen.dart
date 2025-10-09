import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/inventories/cubit/inventory_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/page_title_widget.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/utils/date_parser.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/inventories/inventory_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import 'widgets/inventory_navbar.dart';
import 'widgets/inventory_products.dart';

class AddInventoryScreen extends StatelessWidget {
  const AddInventoryScreen({
    super.key,
    required this.inventoryBloc,
    required this.organization,
    this.stock,
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
              padding: AppUtils.kPaddingAll10,
              child: Column(
                children: [
                  /// header
                  PageTitleWidget(
                    label:
                        'Инвентаризация товаров в складе: ${stock?.name ?? ''} ${inventory == null ? '' : 'от ${DateParser.dayMonthHString(inventory?.createdAt, 'ru')}'}',
                    canPop: true,
                    isMain: false,
                  ),

                  /// body
                  AppUtils.kMainObjectsGap,
                  Expanded(child: AddInventoryProducts(organization, stock)),
                ],
              ),
            ),
            bottomNavigationBar: AddInventoryNavbar(stock, organization)),
      );
}
