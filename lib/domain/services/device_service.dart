import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeviceInfoService {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<MacOsDeviceInfo>? get getMacOsInfo => deviceInfo.macOsInfo;

  Future<WindowsDeviceInfo>? get getWindowsInfo => deviceInfo.windowsInfo;

  Future<String?> get identifier async => Platform.isMacOS
      ? (await getMacOsInfo)?.systemGUID
      : (await getWindowsInfo)?.deviceId;

  Future<String?> get deviceName async => Platform.isMacOS
      ? (await getMacOsInfo)?.computerName
      : (await getWindowsInfo)?.userName;

  Future<String?> get deviceModel async => Platform.isMacOS
      ? (await getMacOsInfo)?.model
      : (await getWindowsInfo)?.computerName;
}
