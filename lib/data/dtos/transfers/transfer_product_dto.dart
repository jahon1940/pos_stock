import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'transfer_product_dto.freezed.dart';
part 'transfer_product_dto.g.dart';

@freezed
class TransferProductDto with _$TransferProductDto {
  factory TransferProductDto({
    required int id,
    ProductDto? product,
    int? purchasePrice,
    int? price,
    int? quantity,
    int? totalPrice,
  }) = _TransferProductDto;

  factory TransferProductDto.fromJson(Map<String, dynamic> json) =>
      _$TransferProductDtoFromJson(json);
}
