import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_refund_info_dto.freezed.dart';
part 'receipt_refund_info_dto.g.dart';

@freezed
class ReceiptRefundInfoDto with _$ReceiptRefundInfoDto {
  factory ReceiptRefundInfoDto({
    @JsonKey(name: "terminalId", includeIfNull: false) String? terminalId,
    @JsonKey(name: "receiptSeq", includeIfNull: false) String? receiptSeq,
    @JsonKey(name: "dateTime", includeIfNull: false) String? dateTime,
    @JsonKey(name: "fiscalSign", includeIfNull: false) String? fiscalSign,
    @JsonKey(name: "receipt_id", includeToJson: false) String? receiptId,
  }) = _ReceiptRefundInfoDto;

  factory ReceiptRefundInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptRefundInfoDtoFromJson(json);
}
