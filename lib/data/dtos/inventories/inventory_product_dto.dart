import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'inventory_product_dto.freezed.dart';
part 'inventory_product_dto.g.dart';

@freezed
class InventoryProductDto with _$InventoryProductDto {
  factory InventoryProductDto({
    required int id,
    ProductDto? product,
    int? oldQuantity,
    int? realQuantity,
    int? quantityDiff,
    String? price,
    int? priceDiff,
  }) = _InventoryProductDto;

  factory InventoryProductDto.fromJson(Map<String, dynamic> json) =>
      _$InventoryProductDtoFromJson(json);
}
