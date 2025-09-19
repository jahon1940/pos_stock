import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_extra_info_dto.freezed.dart';
part 'receipt_extra_info_dto.g.dart';

@freezed
class ReceiptExtraInfoDto with _$ReceiptExtraInfoDto {
  factory ReceiptExtraInfoDto({
    String? tin,
    String? pinfl,
    String? phoneNumber,
    String? carNumber,
    String? cashedOutFromCard,
    @JsonKey(name: "cardType") required int cardType,
    String? pptid
  }) = _ReceiptExtraInfoDto;

  factory ReceiptExtraInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptExtraInfoDtoFromJson(json);
}