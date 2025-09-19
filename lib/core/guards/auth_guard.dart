import 'package:auto_route/auto_route.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';

class AuthGuard extends AutoRouteGuard {
  final userDataService = getIt<UserDataService>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuthorized = userDataService.authorized.value;
    if (isAuthorized) {
      resolver.next();
    } else {
      resolver.redirect(LoginRoute(onResult: () => resolver.next(true)));
    }
  }
}
