import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_dto.freezed.dart';
part 'device_dto.g.dart';

@freezed
class DeviceDto with _$DeviceDto {
  factory DeviceDto({
    required String info,
    required String type,
    required String imei,
    required String name,
    required String appVersion,
  }) = _DeviceDto;

  factory DeviceDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceDtoFromJson(json);
}
