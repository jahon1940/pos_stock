import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';

part 'stock_detail_dto.freezed.dart';
part 'stock_detail_dto.g.dart';

@freezed
class StockDetailDto with _$StockDetailDto {
  const StockDetailDto._();

  factory StockDetailDto({
    int? id,
    StockDto? stock,
    int? quantity,
    int? freeQuantity,
    int? quantityReserve
  }) = _StockDetailDto;

  factory StockDetailDto.fromJson(Map<String, dynamic> json) =>
      _$StockDetailDtoFromJson(json);
}
