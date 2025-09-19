part of 'add_manager_cubit.dart';

@freezed
class AddManagerState with _$AddManagerState {
  const factory AddManagerState({
    @Default(StateStatus.initial) StateStatus status,
    ManagerDto? manager,
    List<ManagerDto>? managers,
  }) = _AddManagerState;
}
