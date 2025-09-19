part of 'shift_cubit.dart';

@freezed
class ShiftState with _$ShiftState {
  const factory ShiftState({
    @Default(StateStatus.initial) StateStatus status,
    ZReportInfoDto? zReport,
    int? cashInSum,
    int? cashOutSum,
    int? progress,
    @Default(false) bool isOpen,
    String? errorText,
    String? statusText,
  }) = _ShiftState;
}
