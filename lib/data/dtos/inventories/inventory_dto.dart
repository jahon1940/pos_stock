import 'package:freezed_annotation/freezed_annotation.dart';

import '../stock_dto.dart';

part 'inventory_dto.freezed.dart';

part 'inventory_dto.g.dart';

@freezed
class InventoryDto with _$InventoryDto {
  factory InventoryDto({
    required int id,
    StockDto? fromStock,
    StockDto? toStock,
    DateTime? createdAt,
    int? totalPurchasePrice,
    int? totalPrice,
    int? supplyProductsCount,
  }) = _InventoryDto;

  factory InventoryDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$InventoryDtoFromJson(json);
}
