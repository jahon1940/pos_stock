import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/payment_type_dto.dart';

import 'epos_discount_card_dto.dart';
import 'epos_product_dto.dart';

part 'receipt_params_dto.freezed.dart';

part 'receipt_params_dto.g.dart';

@freezed
class ReceiptParamsDto with _$ReceiptParamsDto {
  factory ReceiptParamsDto({
    @JsonKey(name: "paycheckNumber", includeIfNull: false)
    String? paycheckNumber,
    @JsonKey(name: "paymentNumber", includeIfNull: false) String? paymentNumber,
    @JsonKey(name: "note", includeIfNull: false) String? note,
    @JsonKey(name: "clientName", includeIfNull: false) String? clientName,
    @JsonKey(name: "stateDuty", includeIfNull: false) String? stateDuty,
    @JsonKey(name: "fineAmount", includeIfNull: false) String? fineAmount,
    @JsonKey(name: "contractSum", includeIfNull: false) String? contractSum,
    @JsonKey(name: "receivedCash") required int receivedCash,
    @JsonKey(name: "receivedCard") required int receivedCard,
    @JsonKey(name: "refundCash", includeIfNull: false) int? refundCash,
    @JsonKey(name: "refundCard", includeIfNull: false) int? refundCard,
    @JsonKey(includeIfNull: false) int? receivedDollar,
    @JsonKey(name: "receivedVat", includeIfNull: false) int? receivedVat,
    @JsonKey(name: "refundVat", includeIfNull: false) int? refundVat,
    @JsonKey(name: "salesCount", includeIfNull: false) int? salesCount,
    @JsonKey(name: "refundsCount", includeIfNull: false) int? refundsCount,
    @JsonKey(name: "discountCard", includeIfNull: false)
    EposDiscountCardDto? discountCard,
    required List<EposProductDto> items,
  }) = _ReceiptParamsDto;

  factory ReceiptParamsDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptParamsDtoFromJson(json);
}

@freezed
class PaymentsDto with _$PaymentsDto {
  factory PaymentsDto(
      {required int id,
      PaymentTypeDto? paymentType,
      int? price}) = _PaymentsDto;
  factory PaymentsDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentsDtoFromJson(json);
}
