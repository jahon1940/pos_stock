import 'package:freezed_annotation/freezed_annotation.dart';

part 'pos_discount_dto.freezed.dart';
part 'pos_discount_dto.g.dart';

@freezed
class PosDiscountDto with _$PosDiscountDto {
  factory PosDiscountDto({
    required int id,
    required String name,
    required int percent
  }) = _PosDiscountDto;

  factory PosDiscountDto.fromJson(Map<String, dynamic> json) =>
      _$PosDiscountDtoFromJson(json);
}