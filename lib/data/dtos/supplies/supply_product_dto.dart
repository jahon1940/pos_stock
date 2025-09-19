import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'supply_product_dto.freezed.dart';
part 'supply_product_dto.g.dart';

@freezed
class SupplyProductDto with _$SupplyProductDto {
  factory SupplyProductDto({
    required int id,
    ProductDto? product,
    int? purchasePrice,
    int? price,
    int? quantity,
    int? totalPrice,
  }) = _SupplyProductDto;

  factory SupplyProductDto.fromJson(Map<String, dynamic> json) =>
      _$SupplyProductDtoFromJson(json);
}
