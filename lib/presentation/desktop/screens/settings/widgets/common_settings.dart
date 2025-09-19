import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/cubit/settings_cubit.dart';

import '../../../../../core/constants/network.dart';
import '../../../../../core/styles/colors.dart';

class CommonSettings extends StatelessWidget {
  const CommonSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Padding(
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
                        context.tr("common_settings"),
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
                                        child: Text(context.tr("fiscal_module")),
                                      ),
                                      AppSpace.horizontal12,
                                      Text(state.posManagerDto?.pos?.gnk_id ?? "Загрузка...")
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
                                        child: Text(context.tr("version")),
                                      ),
                                      AppSpace.horizontal12,

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
                                        child: Text(context.tr("developer_mode")),
                                      ),
                                      AppSpace.horizontal12,
                                      Switch(
                                          value: NetworkConstants.devMode,
                                          onChanged: (bool value) {
                                            context.read<SettingsCubit>().changeDevMode(context);
                                          })
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
        );
      },
    );
  }
}
