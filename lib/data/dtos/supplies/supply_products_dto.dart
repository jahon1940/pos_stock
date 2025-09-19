import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'supply_products_dto.freezed.dart';
part 'supply_products_dto.g.dart';

@freezed
class SupplyProductsDto with _$SupplyProductsDto {
  factory SupplyProductsDto({
    required int id,
    required List<ProductDto> products,
  }) = _SupplyProductsDto;

  factory SupplyProductsDto.fromJson(Map<String, dynamic> json) =>
      _$SupplyProductsDtoFromJson(json);
}
