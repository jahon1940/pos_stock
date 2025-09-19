part of 'add_stock_cubit.dart';

@freezed
class AddStockState with _$AddStockState {
  const factory AddStockState({
    @Default(StateStatus.initial) StateStatus status,
    CurrencyDto? currency,
    @Default(0) int newCurrency,
  }) = _AddStockState;
}
