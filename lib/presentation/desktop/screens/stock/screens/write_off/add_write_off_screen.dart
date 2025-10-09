import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../../data/dtos/write_offs/write_off_dto.dart';
import '../../widgets/page_title_widget.dart';
import 'cubit/write_off_cubit.dart';
import 'widgets/write_off_navbar.dart';
import 'widgets/write_off_products.dart';

class AddWriteOffScreen extends StatelessWidget {
  const AddWriteOffScreen({
    super.key,
    required this.writeOffBloc,
    required this.organization,
    this.writeOff,
    this.stock,
  });

  final WriteOffCubit writeOffBloc;
  final CompanyDto organization;
  final StockDto? stock;
  final WriteOffDto? writeOff;

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider.value(
        value: writeOffBloc..init(writeOff, stock!),
        child: Scaffold(
          backgroundColor: AppColors.softGrey,
          body: Padding(
            padding: AppUtils.kPaddingAll10,
            child: Column(
              children: [
                /// header
                PageTitleWidget(
                  label: 'Списание товаров с склада: ${stock?.name ?? ''}',
                  canPop: true,
                  isMain: false,
                ),

                /// body
                AppUtils.kMainObjectsGap,
                Expanded(child: WriteOffProducts(organization, stock)),
              ],
            ),
          ),
          bottomNavigationBar: WriteOffNavbar(stock, organization),
        ),
      );
}
