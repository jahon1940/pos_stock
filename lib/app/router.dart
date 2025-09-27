import 'package:auto_route/auto_route.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/guards/auth_guard.dart';
import 'package:hoomo_pos/core/guards/locker_guard.dart';
import 'package:injectable/injectable.dart';

AppRouter router = getIt<AppRouter>();

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
            // RedirectRoute(path: '', redirectTo: CartRoute.name),
            // AutoRoute(page: CartParentRoute.page, children: [
            //   AutoRoute(page: CartRoute.page, initial: true),
            //   AutoRoute(page: SiteOrdersRoute.page),
            //   AutoRoute(page: SiteOrderDetailRoute.page)
            // ]),
            AutoRoute(page: SearchRoute.page),
            AutoRoute(
              page: CompaniesRoute.page,
              children: [
                AutoRoute(page: CompanyInfoRoute.page),
              ],
            ),
            AutoRoute(
              page: StockParentRoute.page,
              children: [
                AutoRoute(page: OrganizationRoute.page, initial: true),
                AutoRoute(page: OrganizationItemRoute.page),
                AutoRoute(page: StocksRoute.page),
                AutoRoute(page: StockItemRoute.page),
                AutoRoute(page: AddSuppliesRoute.page),
                AutoRoute(page: AddTransferRoute.page),
                AutoRoute(page: AddWriteOffRoute.page),
                AutoRoute(page: AddInventoryRoute.page),
                AutoRoute(page: AddProductRoute.page),
                AutoRoute(page: AddContractorRoute.page),
                AutoRoute(page: AddManagerRoute.page),
              ],
            ),
            AutoRoute(page: SettingsRoute.page),
            // AutoRoute(page: ReceiptsRoute.page),
            AutoRoute(page: ShiftsRoute.page),
            AutoRoute(page: UnsentRoute.page),
            AutoRoute(page: OrderRoute.page),
            // AutoRoute(page: ReserveParentRoute.page, children: [
            //   AutoRoute(page: ClientOrdersRoute.page, initial: true),
            //   AutoRoute(page: ReserveRoute.page),
            // ]),
            AutoRoute(
              page: Supplies1CParentRoute.page,
              children: [
                AutoRoute(page: Supplies1CRoute.page, initial: true),
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
          ],
        ),
      ];
}
