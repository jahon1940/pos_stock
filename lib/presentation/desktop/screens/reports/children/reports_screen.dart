import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/sale_report_dialog/cubit/sale_report_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/sale_report_dialog/report_dialog.dart';

import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/text_style.dart';
import '../../cubit/user_cubit.dart';

@RoutePage()
class ReportsScreen extends HookWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: AppColors.stroke, blurRadius: 3)
                  ],
                ),
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Отчеты",
                          style: AppTextStyles.boldType18
                              .copyWith(color: AppColors.primary500),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox()
                    ],
                  ),
                ),
              ),
              AppSpace.vertical12,
              Expanded(
                child: CustomBox(
                  child: SizedBox(
                    width: context.width,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              context.pushRoute(RetailReportRoute());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: context.primary),
                              height: 50,
                              width: context.width * .3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Розничная выручка",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 13, color: context.onPrimary),
                                ),
                              ),
                            ),
                          ),
                          AppSpace.vertical12,
                          state.manager?.pos?.integration_with_1c ?? false
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () async {
                                    context.pushRoute(ManagerReportRoute());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: context.primary),
                                    height: 50,
                                    width: context.width * .3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "Менеджеры",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: context.onPrimary),
                                      ),
                                    ),
                                  ),
                                ),
                          AppSpace.vertical12,
                          state.manager?.pos?.integration_with_1c ?? false
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () async {
                                    context.pushRoute(ProductReportRoute());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: context.primary),
                                    height: 50,
                                    width: context.width * .3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "Продукты",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: context.onPrimary),
                                      ),
                                    ),
                                  ),
                                ),
                          AppSpace.vertical12,
                          GestureDetector(
                            onTap: () async {
                              context.showCustomDialog(BlocProvider(
                                create: (context) => getIt<SaleReportCubit>(),
                                child: SaleReportDialog(),
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: context.primary),
                              height: 50,
                              width: context.width * .3,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Скачать Отчет по продажам с детализацией по товарам",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 13, color: context.onPrimary),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }
}
