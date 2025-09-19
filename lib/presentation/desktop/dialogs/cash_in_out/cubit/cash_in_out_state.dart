part of 'cash_in_out_cubit.dart';

@freezed
class CashInOutState with _$CashInOutState {
  const factory CashInOutState({
    @Default(StateStatus.initial) StateStatus status,
  }) = _CashInOutState;
}
