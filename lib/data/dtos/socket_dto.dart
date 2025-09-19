import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_in_stocks_dto.dart';

part 'socket_dto.freezed.dart';
part 'socket_dto.g.dart';

@freezed
class SocketDto with _$SocketDto {
  factory SocketDto({
    int? ordersCount,
    List<ProductInStocksDto>? productInStocks,
  }) = _SocketDto;

  factory SocketDto.fromJson(Map<String, dynamic> json) =>
      _$SocketDtoFromJson(json);
}
