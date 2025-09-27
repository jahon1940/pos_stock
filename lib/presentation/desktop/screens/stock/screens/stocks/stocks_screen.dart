import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stocks/widgets/stocks_list.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stocks/widgets/stocks_title.dart';

import '../../../../../../core/constants/app_utils.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/text_style.dart';
import '../../../../../../core/widgets/custom_box.dart';
import '../../../../../../core/widgets/text_field.dart';
import '../../../../../../data/dtos/company_dto.dart';
import '../../bloc/stock_bloc.dart';

@RoutePage()
class StocksScreen extends HookWidget {
  const StocksScreen({
    super.key,
    required this.organization,
  });

  final CompanyDto organization;

  @override
  Widget build(
    BuildContext context,
  ) {
    final searchController = useTextEditingController();
    return Scaffold(
      body: Padding(
        padding: AppUtils.kPaddingAll10,
        child: Column(
          children: [
            /// search field
            Container(
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
              ),
              height: 60,
              child: Padding(
                padding: AppUtils.kPaddingAll6,
                child: Row(
                  children: [
                    /// back button
                    Container(
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: AppUtils.kBorderRadius12,
                        boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: () => context.pop(),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    /// search field
                    AppUtils.kGap6,
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary100.opcty(.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppTextField(
                          height: 50,
                          hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                          contentPadding: EdgeInsets.all(14),
                          hint: "Поиск склада",
                          fieldController: searchController,
                          suffix: IconButton(icon: Icon(Icons.close), onPressed: () {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppUtils.kGap12,

            Expanded(
              child: CustomBox(
                child: Column(
                  children: [
                    StocksTitle(),
                    BlocBuilder<StockBloc, StockState>(
                      buildWhen: (previous, current) => previous.stocks != current.stocks,
                      builder: (context, state) => state.status.isLoading
                          ? Center(child: CupertinoActivityIndicator())
                          : Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                                itemCount: state.stocks.length,
                                separatorBuilder: (context, index) => AppUtils.kGap12,
                                itemBuilder: (context, index) => StocksList(
                                  organization: organization,
                                  stocks: state.stocks[index],
                                  onDelete: () async {},
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
