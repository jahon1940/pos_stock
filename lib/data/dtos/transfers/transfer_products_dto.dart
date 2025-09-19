import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'transfer_products_dto.freezed.dart';
part 'transfer_products_dto.g.dart';

@freezed
class TransferProductsDto with _$TransferProductsDto {
  factory TransferProductsDto({
    required int id,
    required List<ProductDto> products,
  }) = _TransferProductsDto;

  factory TransferProductsDto.fromJson(Map<String, dynamic> json) =>
      _$TransferProductsDtoFromJson(json);
}
