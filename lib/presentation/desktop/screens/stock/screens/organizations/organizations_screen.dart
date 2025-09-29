import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/table_item_widget.dart';

import '../../../../../../app/router.dart';
import '../../../../../../app/router.gr.dart';
import '../../../../../../core/widgets/custom_box.dart';
import '../../bloc/stock_bloc.dart';
import '../../widgets/page_title_widget.dart';
import '../../widgets/table_title_widget.dart';

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
              /// title
              const PageTitleWidget(label: "Организации"),

              /// body
              AppUtils.kGap12,
              Expanded(
                child: CustomBox(
                  padding: AppUtils.kPaddingAll12.withB0,
                  child: Column(
                    children: [
                      /// table title
                      const TableTitleWidget(titles: ['Номер', 'Название', 'Действия']),

                      /// items
                      AppUtils.kGap12,
                      BlocBuilder<StockBloc, StockState>(
                        buildWhen: (p, c) => p.organizations != c.organizations,
                        builder: (context, state) => state.status.isLoading
                            ? const Center(child: CupertinoActivityIndicator())
                            : Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(vertical: 12).withT0,
                                  itemCount: state.organizations.length,
                                  separatorBuilder: (_, __) => AppUtils.kGap12,
                                  itemBuilder: (context, i) {
                                    final organization = state.organizations.elementAt(i);
                                    return TableItemWidget(
                                      leadingLabel: organization.id.toString(),
                                      bodyLabel: organization.name ?? '',
                                      onTap: () async {
                                        context.stockBloc.add(StockEvent.getStocks(organization.id));
                                        await router.push(OrganizationItemRoute(organization: organization));
                                      },
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
