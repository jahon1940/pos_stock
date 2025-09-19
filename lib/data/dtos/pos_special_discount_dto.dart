import 'package:freezed_annotation/freezed_annotation.dart';

part 'pos_special_discount_dto.freezed.dart';
part 'pos_special_discount_dto.g.dart';

@Freezed()
class PosSpecialDiscountDto with _$PosSpecialDiscountDto {
  factory PosSpecialDiscountDto({
    required bool enableDiscount,
    required int discount
  }) = _PosSpecialDiscountDto;

  factory PosSpecialDiscountDto.fromJson(Map<String, dynamic> json) =>
      _$PosSpecialDiscountDtoFromJson(json);
}