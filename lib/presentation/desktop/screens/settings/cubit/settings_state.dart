part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(StateStatus.initial) StateStatus status,
    @Default(TableType.products) TableType tableType,
    @Default(0) int progress,
    @Default(0) int productsCount,
    @Default(0) int productInStocksCount,
    @Default(false) bool isChange,
    PosManagerDto? posManagerDto,
    DateTime? lastSynchronization,
    String? version,
    String? errorMessage,
  }) = _SettingsState;
}
