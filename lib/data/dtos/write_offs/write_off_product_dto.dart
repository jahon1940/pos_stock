import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'write_off_product_dto.freezed.dart';
part 'write_off_product_dto.g.dart';

@freezed
class WriteOffProductDto with _$WriteOffProductDto {
  factory WriteOffProductDto({
    required int id,
    ProductDto? product,
    int? purchasePrice,
    int? price,
    int? quantity,
    int? totalPrice,
    String? comment,
  }) = _WriteOffProductDto;

  factory WriteOffProductDto.fromJson(Map<String, dynamic> json) =>
      _$WriteOffProductDtoFromJson(json);
}
