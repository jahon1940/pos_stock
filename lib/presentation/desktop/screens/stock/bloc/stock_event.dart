part of 'stock_bloc.dart';

@freezed
class StockEvent with _$StockEvent {
  const factory StockEvent.getStocks(int id) = _GetStocks;
}
