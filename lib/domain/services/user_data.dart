import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/mixins/secure_storage_mixin.dart';
import 'package:injectable/injectable.dart';

@singleton
class UserDataService with SecureStorageMixin {
  final token = ValueNotifier<String?>(null);
  final authorized = ValueNotifier(false);
  final unlocked = ValueNotifier(false);
  final isFirstAuth = ValueNotifier(false);

  Future<void> init() async {
    token.value = await getData(SecureStorageKeys.accessToken);
    authorized.value = token.value != null;
    NetworkConstants.baseHostName = await getData(SecureStorageKeys.baseHostName) ?? "kanstik";
    await getPinCode();
  }

  Future<void> setToken(String? token) async {
    this.token.value = token;
    authorized.value = token != null;
    await writeData(SecureStorageKeys.accessToken, token);
  }

  Future<void> setUnlocked(bool unlocked) async {
    this.unlocked.value = unlocked;
  }

  Future<void> setFirstAuth(bool firstAuth) async {
    isFirstAuth.value = firstAuth;
  }

  Future<void> setPinCode(String pinCode) async {
    await writeData(SecureStorageKeys.pinCode, pinCode);
  }

  Future<String?> getPinCode() async {
    String? pinCode = await getData(SecureStorageKeys.pinCode);
    if (pinCode == null) {
      isFirstAuth.value = true;
    }
    return pinCode;
  }

  Future<void> deletePinCode() async {
    await removeData(SecureStorageKeys.pinCode);
  }
}
