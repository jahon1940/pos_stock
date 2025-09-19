import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKeys {
  pinCode,
  accessToken,
  refreshToken,
  accessExpirationDate,
  refreshExpirationDate,
  frameDefaultProfileId,
  darkMode,
  lastSynchronization,
  baseHostName,
  shift_state,
}

mixin class SecureStorageMixin {
  final storage = FlutterSecureStorage(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: false,
      ),
      iOptions: IOSOptions.defaultOptions.copyWith(
        accessibility: KeychainAccessibility.first_unlock_this_device,
        synchronizable: true,
      ),
      mOptions: MacOsOptions.defaultOptions.copyWith(
        synchronizable: true,
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ));

  Future<void> writeData<T>(SecureStorageKeys key, String? value) async {
    await storage.write(key: key.name, value: value);
  }

  Future<void> removeData<T>(SecureStorageKeys key) async {
    await storage.delete(key: key.name);
  }

  Future<String?> getData(SecureStorageKeys key) async {
    return await storage.read(key: key.name);
  }

  Future<void> deleteSecure() async {
    await storage.deleteAll();
  }
}
