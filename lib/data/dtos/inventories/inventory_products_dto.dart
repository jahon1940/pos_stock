import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'inventory_products_dto.freezed.dart';
part 'inventory_products_dto.g.dart';

@freezed
class InventoryProductsDto with _$InventoryProductsDto {
  factory InventoryProductsDto({
    required int id,
    required List<ProductDto> products,
  }) = _InventoryProductsDto;

  factory InventoryProductsDto.fromJson(Map<String, dynamic> json) =>
      _$InventoryProductsDtoFromJson(json);
}
