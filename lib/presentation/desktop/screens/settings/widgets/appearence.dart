import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/theme_provider.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/cubit/settings_cubit.dart';
import 'package:provider/provider.dart';

import '../../../../../core/styles/colors.dart';

class Appearence extends StatelessWidget {
  const Appearence({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
              width: context.width,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.stroke, width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpace.vertical6,
                      Padding(
                        padding: EdgeInsets.only(
                            left: 24, top: 12, right: 12, bottom: 0),
                        child: Text(
                          context.tr("theme"),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: 300, maxWidth: 430),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<SettingsCubit>()
                                      .changeTheme(themeProvider);
                                },
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: themeProvider.themeMode ==
                                              ThemeMode.light
                                          ? AppColors.primary400
                                          : AppColors.secondary500,
                                      border: Border.all(
                                          color: themeProvider.themeMode ==
                                              ThemeMode.light
                                              ? AppColors.primary100
                                              : AppColors.secondary500,
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          context.tr("light"),
                                          style:
                                              TextStyle(color: AppColors.white),
                                        ),
                                      ),
                                      AppSpace.horizontal12,
                                      Icon(Icons.light_mode,
                                          size: 30, color: AppColors.white),
                                    ],
                                  ),
                                ),
                              ),
                              AppSpace.horizontal48,
                              InkWell(
                                onTap: () {
                                  context
                                      .read<SettingsCubit>()
                                      .changeTheme(themeProvider);
                                },
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: themeProvider.themeMode ==
                                          ThemeMode.dark
                                          ? AppColors.primary400
                                          : AppColors.white,
                                      border: Border.all(
                                          color: themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? AppColors.primary100
                                              : AppColors.secondary500,
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(context.tr("dark")),
                                      ),
                                      AppSpace.horizontal12,
                                      Icon(
                                        Icons.dark_mode,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 120,
                    child: VerticalDivider(
                      color: AppColors.stroke,
                      thickness: 2,
                    ),
                  ),
                  AppSpace.horizontal6,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpace.vertical6,
                      Padding(
                        padding: EdgeInsets.only(
                            left: 12, top: 12, right: 12, bottom: 0),
                        child: Text(
                          context.tr("language"),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: 300, maxWidth: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.setLocale(Locale("ru"));
                                  context.read<SettingsCubit>().changeLanguage();
                                },
                                child: Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: context.locale.languageCode == "ru" ? AppColors.primary400 : AppColors.white,
                                      border: Border.all(
                                          color: AppColors.stroke, width: 1.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Русский язык',
                                          style: TextStyle(
                                            color: context.locale.languageCode == "ru" ? AppColors.white : AppColors.secondary500,
                                          ),
                                        ),
                                      ),
                                      AppSpace.horizontal12,
                                      SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                              'assets/images/ru.png')),
                                    ],
                                  ),
                                ),
                              ),
                              AppSpace.horizontal48,
                              InkWell(
                                onTap: () {
                                  context.setLocale(Locale("uz"));
                                  context.read<SettingsCubit>().changeLanguage();
                                },
                                child: Container(
                                  width: 172,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: context.locale.languageCode == "uz" ? AppColors.primary400 : AppColors.white,
                                      border: Border.all(
                                          color: AppColors.stroke, width: 1.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text("O'zbek tili", style: TextStyle(
                                          color: context.locale.languageCode == "uz" ? AppColors.white : AppColors.secondary500,
                                        )),
                                      ),
                                      AppSpace.horizontal12,
                                      SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                              'assets/images/uz.png')),
                                    ],
                                  ),
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
          );
        }),
      ),
    );
  }
}
