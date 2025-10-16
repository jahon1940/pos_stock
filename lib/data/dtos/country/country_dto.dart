import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_dto.freezed.dart';

part 'country_dto.g.dart';

@freezed
class CountryDto with _$CountryDto {
  factory CountryDto({
    required int id,
    String? name,
    String? fullName,
    String? cid,
  }) = _CountryDto;

  factory CountryDto.fromJson(Map<String, dynamic> json) => _$CountryDtoFromJson(json);
}
