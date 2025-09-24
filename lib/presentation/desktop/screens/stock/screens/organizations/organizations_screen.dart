import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/core/extensions/text_style_extension.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/organizations/widgets/organization_item.dart';

import '../../../../../../core/constants/spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_box.dart';
import '../../bloc/stock_bloc.dart';
import 'widgets/organizations_table_title.dart';

@RoutePage()
class OrganizationScreen extends HookWidget {
  const OrganizationScreen({
    super.key,
  });

  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FlexColumnWidth(1),
    1: FlexColumnWidth(4),
    2: FlexColumnWidth(1),
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
              Container(
                width: context.width,
                height: 60,
                padding: AppUtils.kPaddingL12,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: AppUtils.kBorderRadius12,
                  boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                child: Text(
                  "Организации",
                  style: AppTextStyles.boldType18.withColorPrimary500,
                  textAlign: TextAlign.start,
                ),
              ),

              /// body
              AppUtils.kGap12,
              Expanded(
                child: CustomBox(
                  padding: AppUtils.kPaddingAll12.withB0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
