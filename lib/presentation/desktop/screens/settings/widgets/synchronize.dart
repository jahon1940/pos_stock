import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/cubit/settings_cubit.dart';
import '../../../../../core/styles/colors.dart';

class Synchronize extends StatelessWidget {
  const Synchronize({
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
              boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 8)],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 270,
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
                          left: 24, top: 12, right: 12, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr("data_synchronize"),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          AppSpace.vertical6,
                          Text(
                            context.tr("data_synchronize_desc"),
                            style: TextStyle(
                                fontSize: 12, color: AppColors.secondary100),
                          ),
                        ],
                      ),
                    ),
                    AppSpace.vertical12,
                    Padding(
                      padding: EdgeInsets.only(
                          left: 24, top: 12, right: 12, bottom: 12),
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints(minWidth: 300, maxWidth: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: 170,
                            //   padding: const EdgeInsets.all(8),
                            //   decoration: BoxDecoration(
                            //       color: AppColors.white,
                            //       border: Border.all(
                            //           color: AppColors.stroke, width: 1.5),
                            //       borderRadius: BorderRadius.circular(10)),
                            //   child: const Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       Icon(Icons.check_circle,
                            //           size: 20, color: AppColors.success400),
                            //       AppSpace.horizontal6,
                            //       Padding(
                            //         padding: EdgeInsets.only(left: 5),
                            //         child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               'Компания',
                            //               style: TextStyle(
                            //                   color: AppColors.secondary400),
                            //             ),
                            //             Text(
                            //               'Успешно!',
                            //               style: TextStyle(
                            //                   color: AppColors.success400,
                            //                   fontSize: 10),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // AppSpace.horizontal48,
                            Container(
                              width: 280,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(
                                      color: AppColors.stroke, width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  state.status == StateStatus.loading
                                      ? CupertinoActivityIndicator()
                                      : state.lastSynchronization != null
                                      ? Icon(
                                    Icons.check,
                                    size: 20,
                                    color: AppColors.success500,
                                  )
                                      : Icon(
                                    Icons.info,
                                    size: 20,
                                    color: AppColors.error500,
                                  ),
                                  AppSpace.horizontal6,
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Номенклатура',
                                          style: TextStyle(
                                              color: AppColors.secondary500),
                                        ),
                                        Text(
                                          state.status == StateStatus.loading
                                              ? '${state.progress}%'
                                              : state.lastSynchronization !=
                                              null
                                              ? 'Успешно'
                                              : 'Ошибка!',
                                          style: TextStyle(
                                              color:
                                              state.lastSynchronization !=
                                                  null
                                                  ? AppColors.success500
                                                  : AppColors.error500,
                                              fontSize: 10),
                                        ),

                                        if(state.status != StateStatus.loading)...[
                                          Text("Общее количество товаров: ${FormatterService().formatNumber(state.productsCount.toString())}",
                                            style: TextStyle(
                                                fontSize: 10),
                                          ),
                                          Text("Общее количество товаров в складе: ${FormatterService().formatNumber(state.productInStocksCount.toString())}",
                                            style: TextStyle(
                                                fontSize: 10),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              context.read<SettingsCubit>().synchronize(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: Container(
                              width: 170,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.info900,
                                  border: Border.all(
                                      color: AppColors.stroke, width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                    context.tr("synchronize"),
                                    style: TextStyle(color: AppColors.white),
                                  )),
                            ),
                          ),
                        ),
                        AppSpace.horizontal12,
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            '${context.tr("last_synchronize")}: ${state.lastSynchronization != null ? DateFormat("dd-MM-yyyy HH:mm:ss").format(state.lastSynchronization!) : 'Нет данных'}',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.secondary100),
                          ),
                        )
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

