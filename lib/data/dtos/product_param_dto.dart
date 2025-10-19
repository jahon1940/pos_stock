import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_param_dto.freezed.dart';
part 'product_param_dto.g.dart';

@freezed
class ProductParamDto with _$ProductParamDto {
  factory ProductParamDto({
    required int id,
     String? name,
    String? imageUrl,
  }) = _ProductParamDto;

  factory ProductParamDto.fromJson(Map<String, dynamic> json) =>
      _$ProductParamDtoFromJson(json);
}
