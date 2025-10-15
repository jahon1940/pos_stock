import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_dto.freezed.dart';

part 'brand_dto.g.dart';

@freezed
class BrandDto with _$BrandDto {
  factory BrandDto({
    required int id,
    String? cid,
    @Default('') String name,
    @Default('') String image,
  }) = _BrandDto;

  factory BrandDto.fromJson(Map<String, dynamic> json) => _$BrandDtoFromJson(json);
}
