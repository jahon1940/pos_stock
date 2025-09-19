import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_report_dto.freezed.dart';
part 'manager_report_dto.g.dart';

@freezed
class ManagerReportDto with _$ManagerReportDto {
  factory ManagerReportDto({
    int? id,
    String? article,
    String? title,
    String? receiptType,
    int? quantity,
    int? priceCurrent,
    int? price,
    int? total,
    int? profit,
    int? receiptId,
    String? createdAt,
    int? totalProfit,
    int? totalQuantity,
    int? totalSale,
  }) = _ManagerReportDto;

  factory ManagerReportDto.fromJson(Map<String, dynamic> json) =>
      _$ManagerReportDtoFromJson(json);
}
