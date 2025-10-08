import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/utils/date_parser.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../../data/dtos/transfers/transfer_dto.dart';
import '../../widgets/page_title_widget.dart';
import 'cubit/transfer_cubit.dart';
import 'widgets/transfer_navbar.dart';
import 'widgets/transfer_products.dart';

class AddTransferScreen extends StatelessWidget {
  const AddTransferScreen({
    super.key,
    required this.transferBloc,
    required this.organization,
    this.transfer,
    this.stock,
  });

  final TransferCubit transferBloc;
  final CompanyDto organization;
  final StockDto? stock;
  final TransferDto? transfer;

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider.value(
        value: transferBloc
          ..init(transfer, stock!)
          ..getStocks(organization.id),
        child: Scaffold(
            backgroundColor: AppColors.softGrey,
            body: Padding(
              padding: AppUtils.kPaddingAll10,
              child: Column(
                children: [
                  /// header
                  PageTitleWidget(
                    label:
                        'Перемещение товаров с склада: ${transfer == null ? '' : 'от ${DateParser.dayMonthHString(transfer?.createdAt, 'ru')}'}',
                    canPop: true,
                    isMain: false,
                  ),

                  /// body
                  AppUtils.kMainObjectsGap,
                  Expanded(child: TransferProducts(stock, organization)),
                ],
              ),
            ),
            bottomNavigationBar: TransferNavbar(stock, organization)),
      );
}
