import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/organizations/widgets/organization_item.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/organizations/widgets/page_title_widget.dart';

import '../../../../../../core/constants/spaces.dart';
import '../../../../../../core/widgets/custom_box.dart';
import '../../bloc/stock_bloc.dart';
import 'widgets/organizations_table_title.dart';

@RoutePage()
class OrganizationScreen extends HookWidget {
  const OrganizationScreen({
    super.key,
  });

  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FlexColumnWidth(),
    1: FlexColumnWidth(4),
    2: FlexColumnWidth(),
  };

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        body: Padding(
          padding: AppUtils.kPaddingAll10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// title
              PageTitleWidget(label: "Организации"),

              /// body
              AppUtils.kGap12,
              Expanded(
                child: CustomBox(
                  padding: AppUtils.kPaddingAll12.withB0,
                  child: Column(
                    children: [
                      OrganizationsTableTitle(
                        columnWidths: _columnWidths,
                        titles: ['Номер', 'Название', 'Действия'],
                      ),
                      AppUtils.kGap12,
                      BlocBuilder<StockBloc, StockState>(
                        buildWhen: (p, c) => p.organizations != c.organizations,
                        builder: (context, state) => state.status.isLoading
                            ? Center(child: CupertinoActivityIndicator())
                            : Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(vertical: 12).withT0,
                                  itemCount: state.organizations.length,
                                  separatorBuilder: (context, index) => AppSpace.vertical12,
                                  itemBuilder: (context, index) => OrganizationItem(
                                    organization: state.organizations[index],
                                    columnWidths: _columnWidths,
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
