import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';

part 'transfer_dto.freezed.dart';
part 'transfer_dto.g.dart';

@freezed
class TransferDto with _$TransferDto {
  factory TransferDto({
    required int id,
    StockDto? fromStock,
    StockDto? toStock,
    DateTime? createdAt,
    int? totalPurchasePrice,
    int? totalPrice,
    int? supplyProductsCount,
  }) = _TransferDto;

  factory TransferDto.fromJson(Map<String, dynamic> json) =>
      _$TransferDtoFromJson(json);
}
