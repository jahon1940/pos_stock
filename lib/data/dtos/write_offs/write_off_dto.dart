import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';

part 'write_off_dto.freezed.dart';
part 'write_off_dto.g.dart';

@freezed
class WriteOffDto with _$WriteOffDto {
  factory WriteOffDto({
    required int id,
    StockDto? fromStock,
    StockDto? toStock,
    DateTime? createdAt,
    int? totalPurchasePrice,
    int? totalPrice,
    int? supplyProductsCount,
    String? comment,
  }) = _WriteOffDto;

  factory WriteOffDto.fromJson(Map<String, dynamic> json) =>
      _$WriteOffDtoFromJson(json);
}
