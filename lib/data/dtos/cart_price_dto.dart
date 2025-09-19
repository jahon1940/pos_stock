
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_price_dto.freezed.dart';
part 'cart_price_dto.g.dart';

@freezed
class CartPriceDto with _$CartPriceDto {
  factory CartPriceDto({
    required int price,
    required int priceDiscount,
  }) = _CartPriceDto;

  factory CartPriceDto.fromJson(Map<String, dynamic> json) =>
      _$CartPriceDtoFromJson(json);
}
