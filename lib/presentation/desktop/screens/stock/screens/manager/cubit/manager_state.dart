part of 'manager_cubit.dart';

@freezed
class ManagerState with _$ManagerState {
  const factory ManagerState({
    @Default(StateStatus.initial) StateStatus status,
    ManagerDto? manager,
    List<ManagerDto>? managers,
  }) = _ManagerState;
}
