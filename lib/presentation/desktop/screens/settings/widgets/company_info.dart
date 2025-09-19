import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/cubit/settings_cubit.dart';

import '../../../../../core/styles/colors.dart';

class CompanyInfo extends StatelessWidget {
  const CompanyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: themeData.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 180,
                width: context.width,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.stroke, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpace.vertical6,
                    Padding(
                      padding: EdgeInsets.only(
                          left: 24, top: 12, right: 12, bottom: 12),
                      child: Text(
                        context.tr('company_info'),
                        style: AppTextStyles.boldType24,
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24, top: 12, right: 12, bottom: 0),
                              child: Container(
                                width: 430,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(color: AppColors.stroke, width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(context.tr("company"),
                                          style: AppTextStyles.boldType14),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Text(
                                        state.posManagerDto?.pos?.stock?.organization?.name ?? "",
                                        style: AppTextStyles.mType14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24, top: 12, right: 12, bottom: 0),
                              child: Container(
                                width: 430,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(color: AppColors.stroke, width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(context.tr("stock"),
                                          style: AppTextStyles.boldType14),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Text(
                                        state.posManagerDto?.pos?.stock?.name ?? "",
                                        style: AppTextStyles.mType14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24, top: 12, right: 12, bottom: 0),
                              child: Container(
                                width: 430,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(color: AppColors.stroke, width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(context.tr("address"),
                                          style:
                                          AppTextStyles.boldType14),
                                    ),
                                    AppSpace.horizontal12,
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Text(
                                          state.posManagerDto?.pos?.stock?.address ?? "",
                                          maxLines: 1,
                                          style: AppTextStyles.mType14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24, top: 12, right: 12, bottom: 0),
                              child: Container(
                                width: 430,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                    Border.all(color: AppColors.stroke, width: 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(context.tr("tin_pinfl"),
                                          style:
                                          AppTextStyles.boldType14),
                                    ),
                                    AppSpace.horizontal12,
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Text(
                                        state.posManagerDto?.pos?.stock?.organization?.inn ?? "",
                                        style: AppTextStyles.mType14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
