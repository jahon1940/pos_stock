import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount_card_dto.freezed.dart';
part 'discount_card_dto.g.dart';

@Freezed()
class DiscountCardDto with _$DiscountCardDto {
  factory DiscountCardDto({
    required String card_cid,
    required String card_number,
    required String bonus
  }) = _DiscountCardDto;

  factory DiscountCardDto.fromJson(Map<String, dynamic> json) =>
      _$DiscountCardDtoFromJson(json);
}
