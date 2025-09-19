import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';

part 'product_in_stocks_dto.freezed.dart';
part 'product_in_stocks_dto.g.dart';

@freezed
class ProductInStocksDto with _$ProductInStocksDto {
  factory ProductInStocksDto({
    required int id,
    StockDto? stock,
    int? product,
    int? quantity,
    int? freeQuantity,
    int? quantityReserve,
    num? price,
  }) = _ProductInStocksDto;

  factory ProductInStocksDto.fromJson(Map<String, dynamic> json) =>
      _$ProductInStocksDtoFromJson(json);
}
