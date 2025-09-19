import 'dart:io';

import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/domain/services/device_service.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';
import 'package:hoomo_pos/data/dtos/device_dto.dart';
import 'package:hoomo_pos/data/dtos/login_request.dart';
import 'package:hoomo_pos/data/sources/network/auth_api.dart';
import 'package:hoomo_pos/domain/repositories/auth.dart';
import 'package:injectable/injectable.dart';

import '../../core/logging/app_logger.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._userDataService, this._authApi);

  final UserDataService _userDataService;
  final AuthApi _authApi;

  @override
  Future<String> login(String username, String password) async {
    final device = getIt<DeviceInfoService>();
    try {
      String? deviceId = await device.identifier;
      String? deviceName = await device.deviceModel;
      String? userName = await device.deviceName;

      final deviceData = DeviceDto(
        info: userName ?? '',
        type: Platform.localeName,
        imei: deviceId ?? '',
        name: deviceName ?? '',
        appVersion: '1.0.0',
      );

      final request = LoginRequest(
        username: username,
        password: password,
        device: deviceData,
        fcmToken: 'asdfg',
      );

      final res = await _authApi.login(request);

      return res.deviceToken;
    } catch (e,s) {
      appLogger.e('LOGIN', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> setToken(String token) async {
    try {
      await _userDataService.setToken(token);
    } catch (e) {
      rethrow;
    }
  }
}
