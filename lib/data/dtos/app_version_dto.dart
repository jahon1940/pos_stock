import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version_dto.freezed.dart';
part 'app_version_dto.g.dart';

@freezed
class AppVersionDto with _$AppVersionDto {
  factory AppVersionDto({String? version, String? file}) = _AppVersionDto;

  factory AppVersionDto.fromJson(Map<String, dynamic> json) =>
      _$AppVersionDtoFromJson(json);
}
