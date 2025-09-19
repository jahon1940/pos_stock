import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_user_request.freezed.dart';
part 'add_user_request.g.dart';

@Freezed(fromJson: false, toJson: true)
class AddUserRequest with _$AddUserRequest {
  factory AddUserRequest({
    String? name,
    String? inn,
    String? phoneNumber,
  }) = _AddUserRequest;
}
