part of 'stock_bloc.dart';

@freezed
class StockState with _$StockState {
  const factory StockState({
    @Default(StateStatus.initial) StateStatus status,
    @Default(<StockDto>[]) List<StockDto> stocks,
  }) = _StockState;
}
