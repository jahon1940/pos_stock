import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';

part 'supply_dto.freezed.dart';
part 'supply_dto.g.dart';

@freezed
class SupplyDto with _$SupplyDto {
  factory SupplyDto({
    required int id,
    SupplierDto? supplier,
    int? totalPurchasePrice,
    int? totalPrice,
    int? supplyProductsCount,
    DateTime? createdAt,
  }) = _SupplyDto;

  factory SupplyDto.fromJson(Map<String, dynamic> json) =>
      _$SupplyDtoFromJson(json);
}
