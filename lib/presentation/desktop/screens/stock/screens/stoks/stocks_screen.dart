import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stoks/tabs/contractor.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stoks/tabs/managers.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stoks/tabs/stocks.dart';

import '../../../../../../app/router.dart';
import '../../../../../../core/styles/colors.dart';
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
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          body: Padding(
            padding: AppUtils.kPaddingAll10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// title
                PageTitleWidget(label: organization.name ?? ''),

                ///
                AppUtils.kGap12,
                CustomBox(
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                  ),
                ),

                ///
                AppUtils.kGap12,
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: AppUtils.kBorderRadius10,
                    boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                  ),
                  height: 60,
                  width: context.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                            ),
                            child: InkWell(
                              onTap: () => router.push(OrganizationRoute()),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: context.width * .7,
                        child: Center(
                          child: TabBar(
                            labelPadding: EdgeInsets.zero,
                            padding: EdgeInsets.all(8),
                            indicatorPadding: EdgeInsets.zero,
                            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            indicator: BoxDecoration(borderRadius: BorderRadius.circular(10), color: context.primary),
                            tabs: <Widget>[
                              // for (final index in [0, 1, 2])
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
                        ),
                      ),
                      SizedBox()
                    ],
                  ),
                ),

                ///
                AppUtils.kGap12,
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Stocks(organization),
                      Contractor(organization),
                      Managers(organization),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
