import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'write_off_products_dto.freezed.dart';
part 'write_off_products_dto.g.dart';

@freezed
class WriteOffProductsDto with _$WriteOffProductsDto {
  factory WriteOffProductsDto({
    required int id,
    required List<ProductDto> products,
  }) = _WriteOffProductsDto;

  factory WriteOffProductsDto.fromJson(Map<String, dynamic> json) =>
      _$WriteOffProductsDtoFromJson(json);
}
