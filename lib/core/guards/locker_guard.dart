import 'package:auto_route/auto_route.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';

class LockerGuard extends AutoRouteGuard {
  final userDataService = getIt<UserDataService>();

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final isUnlocked = userDataService.unlocked.value;
    bool isFirstAuth = userDataService.isFirstAuth.value;
    final bool hasPin = await userDataService.getPinCode() != null;

    if (!hasPin) {
      isFirstAuth = true;
    }

    if (isUnlocked) {
      resolver.next();
    } else {
      await resolver.redirect(
        LockerRoute(
          onResult: () {
            userDataService.setUnlocked(true);
            resolver.next();
          },
          isFirstAuth: isFirstAuth,
        ),
      );
    }
  }
}
