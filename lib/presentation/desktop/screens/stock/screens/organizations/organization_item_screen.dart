import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stocks/tabs/managers.dart';

import '../../../../../../app/router.dart';
import '../../../../../../data/dtos/company_dto.dart';
import '../../widgets/page_title_widget.dart';

@RoutePage()
class OrganizationItemScreen extends StatelessWidget {
  const OrganizationItemScreen({
    super.key,
    required this.organization,
  });

  final CompanyDto organization;

  @override
  Widget build(
    BuildContext context,
  ) =>
      DefaultTabController(
        length: 2,
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
                          onPressed: () async => await router.push(StocksRoute(organization: organization)),
                        ),
                        _item(
                          context,
                          label: context.tr("contractor"),
                          onPressed: () async => await router.push(SuppliersRoute(organization: organization)),
                        ),
                        _item(
                          context,
                          label: 'Сотрудники',
                          onPressed: () async => await router.push(ManagersRoute(organization: organization)),
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
              const Icon(
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
                child: const Tab(
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
            Managers(organization),
          ],
        ),
      );
}
