import 'package:freezed_annotation/freezed_annotation.dart';

part 'epos_discount_card_dto.freezed.dart';
part 'epos_discount_card_dto.g.dart';

@Freezed()
class EposDiscountCardDto with _$EposDiscountCardDto {
  factory EposDiscountCardDto({
    required String available,
    required String addition,
    required String subtraction,
    required String remainder
  }) = _EposDiscountCardDto;

  factory EposDiscountCardDto.fromJson(Map<String, dynamic> json) =>
      _$EposDiscountCardDtoFromJson(json);
}