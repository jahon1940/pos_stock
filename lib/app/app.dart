import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hoomo_pos/core/styles/theme_provider.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/blocs/update_cubit/update_cubit_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:updat/updat.dart';
import 'package:updat/updat_window_manager.dart';

class POSApp extends StatefulWidget {
  const POSApp({super.key});

  @override
  State<POSApp> createState() => _POSAppState();
}

class _POSAppState extends State<POSApp> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    _getPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: router.config(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      // builder: packageInfo == null
      //     ? null
      //     : (context, child) => BlocBuilder<UpdateCubit, UpdateCubitState>(
      //           builder: (context, state) {
      //             return UpdatWindowManager(
      //               getLatestVersion: () async {
      //                 return state.appVersion?.version;
      //               },
      //               getBinaryUrl: (latestVersion) async =>
      //                   'https://kanstik.retailer.hoomo.uz/${state.appVersion?.file}',
      //               appName: packageInfo!.appName,
      //               updateChipBuilder: _updateWidget,
      //               currentVersion: packageInfo!.version,
      //               closeOnInstall: true,
      //               callback: print,
      //               child: Overlay(
      //                 initialEntries: [
      //                   OverlayEntry(
      //                     builder: (context) => child!,
      //                   ),
      //                 ],
      //               ),
      //             );
      //           },
      //         ),
    );
  }

  void _getPackageInfo() async {
    await context.read<UpdateCubit>().getUpdate();
    await Future.delayed(Durations.medium1);
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  Widget _updateWidget({
    required String appVersion,
    required void Function() checkForUpdate,
    required BuildContext context,
    required void Function() dismissUpdate,
    required String? latestVersion,
    required Future<void> Function() launchInstaller,
    required void Function() openDialog,
    required void Function() startUpdate,
    required UpdatStatus status,
  }) {
    final size = MediaQuery.sizeOf(context);

    if ([
      UpdatStatus.availableWithChangelog,
      UpdatStatus.checking,
      UpdatStatus.dismissed,
      UpdatStatus.error,
      UpdatStatus.idle,
      UpdatStatus.upToDate,
    ].contains(status)) {
      Timer.periodic(const Duration(hours: 5), (timer) {
        checkForUpdate();
      });

      return const SizedBox();
    }

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            bottom: 24,
            left: 24,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 1, color: context.colorScheme.onSurface),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Доступна новая версия $latestVersion'),
                      SizedBox(width: 24),
                      FilledButton(
                          onPressed: status == UpdatStatus.downloading
                              ? null
                              : status == UpdatStatus.readyToInstall
                                  ? launchInstaller
                                  : startUpdate,
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 32)),
                          ),
                          child: status == UpdatStatus.downloading
                              ? CircularProgressIndicator()
                              : Text(
                                  status == UpdatStatus.available
                                      ? 'Скачать'
                                      : 'Установить',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
