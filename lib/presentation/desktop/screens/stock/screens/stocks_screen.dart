import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/table_item_widget.dart';

import '../../../../../../app/router.dart';
import '../../../../../../app/router.gr.dart';
import '../../../../../../core/constants/app_utils.dart';
import '../../../../../../core/constants/dictionary.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/text_style.dart';
import '../../../../../../core/widgets/custom_box.dart';
import '../../../../../../core/widgets/text_field.dart';
import '../../../../../../data/dtos/company/company_dto.dart';
import '../bloc/stock_bloc.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/table_title_widget.dart';

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
    useEffect(() {
      context.stockBloc.add(StockEvent.getStocks(organization.id));
      return null;
    }, const []);
    final searchController = useTextEditingController();
    return Scaffold(
      body: Padding(
        padding: AppUtils.kPaddingAll10,
        child: Column(
          children: [
            /// search field
            Container(
              padding: AppUtils.kPaddingAll6,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
              ),
              height: 60,
              child: Row(
                children: [
                  /// back button
                  const BackButtonWidget(),

                  /// search field
                  AppUtils.kGap6,
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.opcty(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppTextField(
                        hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                        contentPadding: const EdgeInsets.all(14),
                        hint: 'Поиск склада',
                        fieldController: searchController,
                        suffix: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppUtils.kGap12,

            Expanded(
              child: CustomBox(
                padding: AppUtils.kPaddingAll12.withB0,
                child: Column(
                  children: [
                    const TableTitleWidget(titles: ['Номер', 'Название', 'Действия']),

                    ///
                    AppUtils.kGap12,
                    BlocBuilder<StockBloc, StockState>(
                      buildWhen: (p, c) => p.stocks != c.stocks,
                      builder: (context, state) => Expanded(
                        child: state.status.isLoading
                            ? const Center(child: CupertinoActivityIndicator())
                            : state.stocks.isEmpty
                                ? Center(child: Text(context.tr(Dictionary.not_found)))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(vertical: 12).withT0,
                                    itemCount: state.stocks.length,
                                    separatorBuilder: (context, index) => AppUtils.kGap12,
                                    itemBuilder: (context, i) {
                                      final stock = state.stocks.elementAt(i);
                                      return TableItemWidget(
                                        leadingLabel: stock.id.toString(),
                                        bodyLabel: stock.name,
                                        onTap: () => router.push(StockItemRoute(
                                          stock: stock,
                                          organization: organization,
                                        )),
                                      );
                                    },
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
