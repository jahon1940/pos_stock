import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/widgets/appearence.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/widgets/common_settings.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/widgets/company_info.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/widgets/synchronize.dart';

import '../../../../core/styles/colors.dart';

@RoutePage()
class SettingsScreen extends HookWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          children: [
            CompanyInfo(),
            CommonSettings(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 210,
                    width: context.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.stroke, width: 1.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 24, top: 12, right: 12, bottom: 0),
                          child: Text(
                            context.tr("printer_settings"),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 300, maxWidth: 500),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  spacing: 20,
                                  children: [
                                    Container(
                                      width: 400,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.stroke,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(context.tr("printers")),
                                          ),
                                          AppSpace.horizontal12,
                                          Text('Canon 850x')
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 400,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.stroke,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(context.tr("code")),
                                          ),
                                          AppSpace.horizontal12,
                                          Text('cp866')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppSpace.horizontal12,
                            SizedBox(
                              height: 120,
                              child: VerticalDivider(
                                color: AppColors.stroke,
                                thickness: 2,
                              ),
                            ),
                            AppSpace.horizontal12,
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 300, maxWidth: 500),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  spacing: 20,
                                  children: [
                                    Container(
                                      width: 400,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.stroke,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                                context.tr("print_qr_image")),
                                          ),
                                          AppSpace.horizontal12,
                                          Switch(
                                              value: true,
                                              onChanged: (bool value) {})
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 400,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.stroke,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(context.tr("printer_size")),
                                          ),
                                          AppSpace.horizontal12,
                                          Text('80')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Appearence(),
            Synchronize(),
          ],
        ),
      ),
    );
  }
}
