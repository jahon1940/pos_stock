part of 'report_manager_cubit.dart';

@freezed
class ReportManagerState with _$ReportManagerState {
  const factory ReportManagerState(
      {@Default(StateStatus.initial) StateStatus status,
      @Default(<ManagerDto>[]) List<ManagerDto> managers,
      ManagerDto? selectedManager,
      ProductDto? selectedProduct,
      DateTime? dateFrom,
      DateTime? dateTo,
      List<ManagerReportDto>? managerReports,
      ManagerReportDto? managerReportsTotal}) = _ReportManagerState;
}
