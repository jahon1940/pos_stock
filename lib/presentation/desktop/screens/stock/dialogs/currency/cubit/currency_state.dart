part of 'currency_cubit.dart';

@freezed
class CurrencyState with _$CurrencyState {
  const factory CurrencyState({
    @Default(StateStatus.initial) StateStatus status,
    CurrencyDto? currency,
    @Default(0) int newCurrency,
  }) = _CurrencyState;
}
