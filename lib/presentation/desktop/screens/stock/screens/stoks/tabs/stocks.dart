import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import '../../../../../../../core/constants/spaces.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../data/dtos/company_dto.dart';
import '../../../bloc/stock_bloc.dart';
import '../widgets/stocks_list.dart';
import '../widgets/stocks_title.dart';

class Stocks extends HookWidget {
  const Stocks(
    this.organization, {
    super.key,
  });
  final CompanyDto organization;
  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeData.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppTextField(
                        radius: 8,
                        height: 50,
                        hintStyle: AppTextStyles.mType16
                            .copyWith(color: AppColors.primary500),
                        contentPadding: EdgeInsets.all(14),
                        hint: "Поиск склада",
                        fieldController: searchController,
                        suffix: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.close), onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  // GestureDetector(
                  //   onTap: () {
                  //     router.push(AddContractorRoute()).then((_) {
                  //       context.read<AddContractorCubit>().getSuppliers();
                  //     });
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(5),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(8),
                  //         color: context.primary),
                  //     height: 50,
                  //     width: context.width * .1,
                  //     child: Center(
                  //       child: Text(
                  //         "Добавить",
                  //         maxLines: 2,
                  //         style:
                  //         TextStyle(fontSize: 13, color: context.onPrimary),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          AppSpace.vertical12,
          Expanded(
            child: CustomBox(
              child: Column(
                children: [
                  StocksTitle(),
                  BlocBuilder<StockBloc, StockState>(
                    buildWhen: (previous, current) =>
                        previous.stocks != current.stocks,
                    builder: (context, state) {
                      if (state.status == StateStatus.loading) {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      return Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                          itemBuilder: (context, index) => StocksList(
                            organization: organization,
                            stocks: state.stocks[index],
                            onDelete: () async {},
                          ),
                          separatorBuilder: (context, index) =>
                              AppSpace.vertical12,
                          itemCount: state.stocks.length,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
