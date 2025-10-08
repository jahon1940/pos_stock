import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/utils/date_parser.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/supplies/cubit/supply_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/page_title_widget.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import 'widgets/supplies_navbar.dart';
import 'widgets/supplies_products.dart';

class AddSuppliesScreen extends HookWidget {
  const AddSuppliesScreen({
    super.key,
    required this.supplyBloc,
    required this.organization,
    required this.stock,
    this.supply,
  });

  final SupplyCubit supplyBloc;
  final CompanyDto organization;
  final StockDto stock;
  final SupplyDto? supply;

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider.value(
        value: supplyBloc..init(supply, stock),
        child: Scaffold(
            backgroundColor: AppColors.softGrey,
            body: Padding(
              padding: AppUtils.kPaddingAll10,
              child: Column(
                children: [
                  /// header
                  PageTitleWidget(
                    label:
                        'Поступление товаров в склад: ${stock.name} ${supply == null ? '' : 'от ${DateParser.dayMonthHString(supply?.createdAt, 'ru')}'} ',
                    canPop: true,
                    isMain: false,
                  ),

                  /// body
                  AppUtils.kMainObjectsGap,
                  const Expanded(child: SuppliesProducts()),
                ],
              ),
            ),
            bottomNavigationBar: SuppliesNavbar(stock, organization)),
      );
}
