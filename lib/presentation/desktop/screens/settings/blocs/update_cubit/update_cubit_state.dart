part of 'update_cubit_cubit.dart';

@freezed
class UpdateCubitState with _$UpdateCubitState {
  const factory UpdateCubitState({
    AppVersionDto? appVersion,
    @Default(false) bool showUpdater,
  }) = _UpdateCubitState;
}
