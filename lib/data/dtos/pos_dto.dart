import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/payment_type_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';

part 'pos_dto.freezed.dart';
part 'pos_dto.g.dart';

@freezed
class PosDto with _$PosDto {
  const PosDto._();

  factory PosDto({
    required int id,
    required String name,
    String? gnk_id,
    bool? status,
    bool? enable_no_fiscal_sale,
    bool? manager_sale,
    bool? payment_dollar,
    bool? show_purchase_price,
    bool? edit_price,
    bool? integration_with_1c,
    List<PaymentTypeDto>? paymentTypes,
    StockDto? stock
  }) = _PosDto;

  factory PosDto.fromJson(Map<String, dynamic> json) =>
      _$PosDtoFromJson(json);
}
