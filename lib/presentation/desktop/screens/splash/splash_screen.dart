import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/presentation/desktop/screens/splash/cubit/splash_cubit.dart';

@RoutePage()
class SplashScreen extends StatelessWidget implements AutoRouteWrapper {
  const SplashScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            context.replaceRoute(const MainRoute());
          } else if (state is Unauthorized) {
            context.replaceRoute(LoginRoute());
          }
        },
        child: Scaffold(
          body: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr('cashbox_run'),
                  style: TextTheme.of(context).headlineLarge,
                ),
                AppSpace.vertical24,
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );

  @override
  Widget wrappedRoute(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<SplashCubit>(),
        child: this,
      );
}
