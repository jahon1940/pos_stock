import 'package:freezed_annotation/freezed_annotation.dart';

part 'region_dto.freezed.dart';
part 'region_dto.g.dart';

@freezed
class RegionDto with _$RegionDto {
  const RegionDto._();

  factory RegionDto({
    required int id,
    required String name,
  }) = _RegionDto;

  factory RegionDto.fromJson(Map<String, dynamic> json) =>
      _$RegionDtoFromJson(json);
}
