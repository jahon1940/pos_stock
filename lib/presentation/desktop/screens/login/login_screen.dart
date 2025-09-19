import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/change_server_host/change_server_host.dart';
import 'package:hoomo_pos/presentation/desktop/screens/login/cubit/login_cubit.dart';

import '../../../../core/styles/colors.dart';

@RoutePage()
class LoginScreen extends HookWidget implements AutoRouteWrapper {
  const LoginScreen({super.key, this.onResult});

  final VoidCallback? onResult;

  @override
  Widget build(BuildContext context) {
    final userNameController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor:
                  Colors.transparent,
                  elevation: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior
                        .translucent,
                    // Позволяет ловить клики за пределами диалога
                    onTap: () =>
                        Navigator.of(context)
                            .pop(),
                    // Закрываем диалог при нажатии вне
                    child: Align(
                      alignment:
                      Alignment.topCenter,
                      // Размещаем диалог выше
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 50),
                        // Отступ сверху
                        child: GestureDetector(
                          onTap: () {},
                          // Блокируем закрытие при клике на сам диалог
                          child: ChangeServerHost(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, icon: Icon(Icons.settings)),
          )
        ],
      ),
      backgroundColor: AppColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300, maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppSpace.vertical48,
              SizedBox(
                  width: 150,
                  height: 80,
                  child: Image.asset('assets/images/logo.png')),
              AppSpace.vertical32,
              Text(
                context.tr("login_desc"),
                style: AppTextStyles.rType16,
                textAlign: TextAlign.center,
              ),
              AppSpace.vertical32,
              AppTextField(
                width: 380,
                label: context.tr("login"),
                enabledBorderWith: 1,
                enabledBorderColor: AppColors.stroke,
                focusedBorderColor: AppColors.stroke,
                focusedBorderWith: 1,
                fieldController: userNameController,
              ),
              AppSpace.vertical32,
              AppTextField(
                width: 380,
                label: context.tr("password"),
                enabledBorderWith: 1,
                enabledBorderColor: AppColors.stroke,
                focusedBorderColor: AppColors.stroke,
                focusedBorderWith: 1,
                obscureText: true,
                fieldController: passwordController,
              ),
              AppSpace.vertical32,
              BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state is LoginFailed) ...[
                        Text(
                          state.error,
                          style: context.bodyLarge
                              ?.copyWith(color: AppColors.error500),
                        ),
                        AppSpace.vertical12,
                      ],
                      MaterialButton(
                        onPressed: () => context.read<LoginCubit>().login(
                              onResult,
                              userNameController.text,
                              passwordController.text,
                            ),
                        minWidth: 380,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        color: AppColors.primary500,
                        textTheme: ButtonTextTheme.primary,
                        child: state is LoginLoading
                            ? CupertinoActivityIndicator(
                                color: AppColors.white,
                              )
                            : Text(context.tr("sign_in")),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: this,
    );
  }
}
