part of 'stock_bloc.dart';

@freezed
class StockEvent with _$StockEvent {
  const factory StockEvent.getStocks(int id) = _GetStocks;

  const factory StockEvent.downloadTransfers(int id) = _DownloadTransfers;

  const factory StockEvent.deleteTransfer(int id) = _DeleteTransfer;

  const factory StockEvent.searchWriteOffs(int stockId, bool? initial) = _SearchWriteOffs;

  const factory StockEvent.downloadWriteOffs(int id) = _DownloadWriteOffs;

  const factory StockEvent.deleteWriteOff(int id) = _DeleteWriteOff;

  const factory StockEvent.deleteInventory(int id) = _DeleteInventory;

  const factory StockEvent.toStockId(int? id) = _ToStockId;

  const factory StockEvent.dateFrom(DateTime dateFrom) = _DateFrom;

  const factory StockEvent.dateTo(DateTime dateTo) = _DateTo;
}
