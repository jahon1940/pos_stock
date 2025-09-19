part of 'sale_report_cubit.dart';

@freezed
class SaleReportState with _$SaleReportState {
  const factory SaleReportState({
    @Default(StateStatus.initial) StateStatus status,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) = _SaleReportState;
}
