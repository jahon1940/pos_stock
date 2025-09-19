import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_reserve_product_dto.freezed.dart';
part 'create_reserve_product_dto.g.dart';

@freezed
class CreateReserveProductDto with _$CreateReserveProductDto {
  const CreateReserveProductDto._();

  factory CreateReserveProductDto({
    required int product,
    required int quantity,
    required double price,
    required int vatPercent,
    required int vat
  }) = _CreateReserveProductDto;

  factory CreateReserveProductDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReserveProductDtoFromJson(json);
}
