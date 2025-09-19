import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/device_dto.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@Freezed(fromJson: false, toJson: true)
class LoginRequest with _$LoginRequest {
  factory LoginRequest({
    required String username,
    required String password,
    required String fcmToken,
    required DeviceDto device,
  }) = _LoginRequest;
}
