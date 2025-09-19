import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

part 'reserve_product_dto.freezed.dart';
part 'reserve_product_dto.g.dart';

@freezed
class ReserveProductDto with _$ReserveProductDto {
  const ReserveProductDto._();

  factory ReserveProductDto({
    required ProductDto product,
    required int quantity,
    required double price,
    required int vatPercent,
    required int vat
  }) = _ReserveProductDto;

  factory ReserveProductDto.fromJson(Map<String, dynamic> json) =>
      _$ReserveProductDtoFromJson(json);
}