import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_dto.freezed.dart';
part 'manager_dto.g.dart';

@freezed
class ManagerDto with _$ManagerDto {
  factory ManagerDto({
    required String cid,
    int? id,
    String? name,
    String? phoneNumber,
    String? position,
  }) = _ManagerDto;

  factory ManagerDto.fromJson(Map<String, dynamic> json) =>
      _$ManagerDtoFromJson(json);
}
