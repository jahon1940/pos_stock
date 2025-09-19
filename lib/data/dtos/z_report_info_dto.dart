import 'package:freezed_annotation/freezed_annotation.dart';

part 'z_report_info_dto.freezed.dart';
part 'z_report_info_dto.g.dart';

@freezed
class ZReportInfoDto with _$ZReportInfoDto {
  const ZReportInfoDto._();

  factory ZReportInfoDto({
    required int? number,
    required int? count,
    String? error,
    @JsonKey(name: "totalSaleCount") required int? totalSaleCount,
    @JsonKey(name: "totalRefundCount") required int? totalRefundCount,
    @JsonKey(name: "totalRefundVAT") required int? totalRefundVAT,
    @JsonKey(name: "totalRefundCash") required int? totalRefundCash,
    @JsonKey(name: "totalRefundCard") required int? totalRefundCard,
    @JsonKey(name: "totalSaleCard") required int? totalSaleCard,
    @JsonKey(name: "totalSaleCash") required int? totalSaleCash,
    @JsonKey(name: "totalSaleVAT") required int? totalSaleVAT,
    @JsonKey(name: "closeTime") required String? closeTime,
    @JsonKey(name: "terminalID") required String? terminalID,
    @JsonKey(name: "openTime") required String? openTime,
    @JsonKey(name: "appletVersion") required String? appletVersion,
    String? companyName,
    String? stockName,
    String? stockAddress,
    String? cashier,
    String? companyTin,
  }) = _ZReportInfoDto;

  bool get isOpen => openTime != null;

  factory ZReportInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ZReportInfoDtoFromJson(json);
}