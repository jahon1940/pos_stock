import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/contract_dto.dart';
import 'package:hoomo_pos/data/dtos/reserve_product_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';

import 'company/company_dto.dart';

part 'reserve_dto.freezed.dart';
part 'reserve_dto.g.dart';

@freezed
class ReserveDto with _$ReserveDto {
  const ReserveDto._();

  factory ReserveDto({
    required int id,
    required String paymentDate,
    required String shipmentDate,
    CompanyDto? company,
    StockDto? stock,
    ContractDto? contract,
    required bool is_realized,
    required List<ReserveProductDto> products,
    String? note,
    int? totalPrice
  }) = _ReserveDto;

  factory ReserveDto.fromJson(Map<String, dynamic> json) =>
      _$ReserveDtoFromJson(json);
}
