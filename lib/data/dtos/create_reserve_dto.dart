import 'package:freezed_annotation/freezed_annotation.dart';
import 'create_reserve_product_dto.dart';

part 'create_reserve_dto.freezed.dart';
part 'create_reserve_dto.g.dart';

@freezed
class CreateReserveDto with _$CreateReserveDto {
  const CreateReserveDto._();

  factory CreateReserveDto({
    required int id,
    required String paymentDate,
    required String shipmentDate,
    required int company,
    required int contract,
    required List<CreateReserveProductDto> products,
    String? note
  }) = _CreateReserveDto;

  factory CreateReserveDto.fromJson(Map<String, dynamic> json) =>
      _$CreateReserveDtoFromJson(json);
}