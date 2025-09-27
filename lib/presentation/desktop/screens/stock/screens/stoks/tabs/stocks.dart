import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
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
  Widget build(
    BuildContext context,
  ) {
    final searchController = useTextEditingController();
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
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
                    buildWhen: (previous, current) => previous.stocks != current.stocks,
                    builder: (context, state) => state.status.isLoading
                        ? Center(child: CupertinoActivityIndicator())
                        : Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                              itemCount: state.stocks.length,
                              separatorBuilder: (context, index) => AppSpace.vertical12,
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
    );
  }
}
