import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'cart_product_dto.freezed.dart';
part 'cart_product_dto.g.dart';

@freezed
class CartProductDto with _$CartProductDto {
  factory CartProductDto({
    required int id,
    ProductDto? product,
    required int quantity,
    required int price,
    int? priceSum,
    @Default(false) bool fromSite,
    @Default(false) bool isAccepted,
    int? discount,
  }) = _CartProductDto;

  factory CartProductDto.fromJson(Map<String, dynamic> json) =>
      _$CartProductDtoFromJson(json);
}
