import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import '../sources/app_database.dart';

part 'order_product_dto.freezed.dart';

@Freezed(toJson: false)
class OrderProductDto with _$OrderProductDto {
  factory OrderProductDto({
    required int id,
    required int quantity,
    required int price,
    required ProductDto product,
    String? name,
  }) = _OrderProductDto;

  factory OrderProductDto.fromJson(Map<String, dynamic> json) {
    (int, int, int)? result;

    for (var item in json['product']['stocks']) {
      result =
      (item['free_quantity'], item['quantity'], item['quantity_reserve']);
    }

    return OrderProductDto(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      price: json['price'] as int,
      name: json['name'] as String?,
      product: ProductDto.toDto(
        Products.fromJson(json['product'] as Map<String, dynamic>),
        quantity: result,
      ),
    );
  }
}