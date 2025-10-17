import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/guards/auth_guard.dart';
import 'package:hoomo_pos/core/guards/locker_guard.dart';
import 'package:injectable/injectable.dart';

import '../core/custom_packages/custom_chuck/chuck.dart';

AppRouter router = getIt<AppRouter>();

final chuck = Chuck(
  navigatorKey: router.navigatorKey,
  clearCallsWithoutConfirming: true,
  showDeleteButtonOnAppBar: true,
  showMenuButtonOnAppBar: false,
  // ignore: avoid_redundant_argument_values
  showNotification: kDebugMode,
);

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: LockerRoute.page),
        AutoRoute(
          page: MainRoute.page,
          guards: [
            AuthGuard(),
            LockerGuard(),
          ],
          children: [
            AutoRoute(page: SearchRoute.page),
            AutoRoute(
              page: CompaniesRoute.page,
              children: [
                AutoRoute(page: CompanyInfoRoute.page),
              ],
            ),
            AutoRoute(
              page: SupplierParentRoute.page,
              children: [
                AutoRoute(page: SuppliersRoute.page, initial: true),
                AutoRoute(page: AddSupplierRoute.page),
              ],
            ),
            AutoRoute(
              page: ManagersParentRoute.page,
              children: [
                AutoRoute(page: ManagersRoute.page, initial: true),
                AutoRoute(page: AddManagerRoute.page),
              ],
            ),
            AutoRoute(
              page: ReportsParentRoute.page,
              children: [
                AutoRoute(page: ReportsRoute.page, initial: true),
                AutoRoute(page: ManagerReportRoute.page),
                AutoRoute(page: ProductReportRoute.page),
                AutoRoute(page: RetailReportRoute.page)
              ],
            ),
            AutoRoute(
              page: StockParentRoute.page,
              children: [
                AutoRoute(page: OrganizationRoute.page, initial: true),
                AutoRoute(page: StocksRoute.page),
                AutoRoute(page: StockItemRoute.page),
                AutoRoute(page: CreateProductRoute.page),
              ],
            ),
            AutoRoute(page: SettingsRoute.page),
          ],
        ),
      ];
}
