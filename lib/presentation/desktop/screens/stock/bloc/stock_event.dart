part of 'stock_bloc.dart';

@freezed
class StockEvent with _$StockEvent {
  const factory StockEvent.getStocks(int id) = _GetStocks;

  const factory StockEvent.searchWriteOffs(int stockId, bool? initial) = _SearchWriteOffs;

  const factory StockEvent.downloadWriteOffs(int id) = _DownloadWriteOffs;

  const factory StockEvent.dateFrom(DateTime dateFrom) = _DateFrom;

  const factory StockEvent.dateTo(DateTime dateTo) = _DateTo;
}
