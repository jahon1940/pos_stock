import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/organizations/widgets/organizations_list.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/organizations/widgets/organizations_title.dart';

import '../../../../../../core/constants/spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_box.dart';
import '../../bloc/stock_bloc.dart';

@RoutePage()
class OrganizationScreen extends HookWidget {
  const OrganizationScreen({
    super.key,
  });

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
              Container(
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                height: 60,
                width: context.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 15, 0, 0),
                  child: Text(
                    "Организации",
                    style: AppTextStyles.boldType18.copyWith(color: AppColors.primary500),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              AppSpace.vertical12,
              Expanded(
                child: CustomBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OrganizationsTitle(),
                      BlocBuilder<StockBloc, StockState>(
                        buildWhen: (p, c) => p.organizations != c.organizations,
                        builder: (context, state) => state.status.isLoading
                            ? Center(child: CupertinoActivityIndicator())
                            : Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                                  itemBuilder: (context, index) => OrganizationsList(
                                    organization: state.organizations[index],
                                    onDelete: () async {},
                                  ),
                                  separatorBuilder: (context, index) => AppSpace.vertical12,
                                  itemCount: state.organizations.length,
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
