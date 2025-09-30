import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/utils/date_parser.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_transfer/widgets/transfer_navbar.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_transfer/widgets/transfer_products.dart';
import '../../../../../../core/constants/spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/text_style.dart';
import '../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../data/dtos/transfers/transfer_dto.dart';
import 'cubit/add_transfer_cubit.dart';

@RoutePage()
class AddTransferScreen extends HookWidget implements AutoRouteWrapper {
  const AddTransferScreen(
    this.organization, {
    super.key,
    this.transfer,
    this.stock,
  });

  final CompanyDto organization;
  final StockDto? stock;
  final TransferDto? transfer;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<AddTransferCubit>().getStocks(organization.id);
      return null;
    }, const []);
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
                        'Перемещение товаров с склада: ${transfer == null ? '' : 'от ${DateParser.dayMonthHString(transfer?.createdAt, 'ru')}'}',
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              AppSpace.vertical12,
              Expanded(child: TransferProducts(stock, organization)),
            ],
          ),
        ),
        bottomNavigationBar: TransferNavbar(stock, organization));
  }

  @override
  Widget wrappedRoute(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<AddTransferCubit>()..init(transfer, stock!),
        child: this,
      );
}
