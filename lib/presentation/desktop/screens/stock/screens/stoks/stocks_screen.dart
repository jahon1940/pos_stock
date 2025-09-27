import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/presentation/desktop/screens/contractor/screens/contractor_screen.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stoks/tabs/managers.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stoks/tabs/stocks.dart';

import '../../../../../../data/dtos/company_dto.dart';
import '../organizations/widgets/page_title_widget.dart';

@RoutePage()
class StocksScreen extends StatelessWidget {
  const StocksScreen({
    super.key,
    required this.organization,
  });

  final CompanyDto organization;

  @override
  Widget build(
    BuildContext context,
  ) =>
      DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Padding(
            padding: AppUtils.kPaddingAll10,
            child: Column(
              children: [
                /// title
                PageTitleWidget(
                  label: organization.name ?? '',
                  canPop: true,
                ),

                ///
                AppUtils.kGap12,
                CustomBox(
                  padding: AppUtils.kPaddingAll12,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      spacing: AppUtils.kGap12.mainAxisExtent,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _item(
                          context,
                          label: 'Склад',
                          onPressed: () {},
                        ),
                        _item(
                          context,
                          label: context.tr("contractor"),
                          onPressed: () {},
                        ),
                        _item(
                          context,
                          label: 'Сотрудники',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                ///
                AppUtils.kGap12,
                _tabbar(context),

                ///
                AppUtils.kGap12,
                _view(context),
              ],
            ),
          ),
        ),
      );

  Widget _item(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) =>
      GestureDetector(
        onTap: onPressed,
        child: Container(
          width: context.width * .3,
          height: 50,
          padding: AppUtils.kPaddingHor12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: context.onPrimary),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      );

  Widget _tabbar(BuildContext context) => Container(
        color: Colors.yellow,
        child: TabBar(
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          tabs: [
            FittedBox(
              child: SizedBox(
                width: context.width * .17,
                child: Tab(
                  child: Text(
                    "Склад",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            FittedBox(
              child: SizedBox(
                width: context.width * .17,
                child: Tab(
                  child: Text(
                    context.tr("contractor"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            FittedBox(
              child: SizedBox(
                width: context.width * .17,
                child: Tab(
                  child: Text(
                    "Сотрудники",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _view(BuildContext context) => Expanded(
        child: TabBarView(
          children: <Widget>[
            Stocks(organization),
            ContractorScreen(organization),
            Managers(organization),
          ],
        ),
      );
}
