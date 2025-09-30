import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/utils/date_parser.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import '../../../../../../../../core/constants/spaces.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import 'cubit/add_supplies_cubit.dart';
import 'widgets/supplies_navbar.dart';
import 'widgets/supplies_products.dart';

@RoutePage()
class AddSuppliesScreen extends HookWidget implements AutoRouteWrapper {
  const AddSuppliesScreen(
    this.organization, {
    super.key,
    this.supply,
    required this.stock,
  });

  final CompanyDto organization;
  final StockDto stock;
  final SupplyDto? supply;

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
                      'Поступление товаров в склад: ${stock.name} ${supply == null ? '' : 'от ${DateParser.dayMonthHString(supply?.createdAt, 'ru')}'} ',
                      style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              AppSpace.vertical12,
              const Expanded(child: SuppliesProducts()),
            ],
          ),
        ),
        bottomNavigationBar: SuppliesNavbar(stock, organization));
  }

  @override
  Widget wrappedRoute(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<AddSuppliesCubit>()..init(supply, stock),
        child: this,
      );
}
