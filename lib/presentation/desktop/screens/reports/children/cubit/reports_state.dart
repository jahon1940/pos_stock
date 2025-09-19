part of 'reports_cubit.dart';

@freezed
class ReportsState with _$ReportsState {
  const factory ReportsState({
    @Default(StateStatus.initial) StateStatus status,
    ProductsInfoDto? info,
    List<RetailReportTotal>? reportTotal,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) = _ReportsState;
}
