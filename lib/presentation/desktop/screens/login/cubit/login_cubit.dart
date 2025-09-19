import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/sources/network/pos_api.dart';
import 'package:hoomo_pos/domain/repositories/auth.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final PosApi _posApi;

  LoginCubit(this._authRepository, this._posApi) : super(LoginInitial());

  void rememberToggle() {
    emit(LoginInitial(remember: !state.remember));
  }

  void login(VoidCallback? onResult, String userName, String password) async {
    emit(LoginLoading(remember: state.remember));

    try {
      final res = await _authRepository.login(userName, password);
      await _authRepository.setToken(res);
      getIt<DioClient>().setAuthToken(res);
      await _posApi.getPos();
      onResult == null ? router.replaceAll([MainRoute()]) : onResult();
    } on DioException catch (e) {
      emit(LoginFailed(
          remember: state.remember,
          error: e.response?.data['message'][0].toString() ?? ''));
    } catch (e) {
      emit(LoginFailed(remember: state.remember, error: e.toString()));
    }
  }
}
