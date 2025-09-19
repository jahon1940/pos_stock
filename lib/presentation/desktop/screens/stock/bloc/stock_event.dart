part of 'stock_bloc.dart';

@freezed
class StockEvent with _$StockEvent {
  const factory StockEvent.getOrganizations() = _GetOrganizations;
  const factory StockEvent.getStocks(int id) = _GetStocks;
  const factory StockEvent.searchSupplies(int stockId, bool? initial) =
      _SearchSupplies;
  const factory StockEvent.downloadSupplies(int id) = _DownloadSupplies;
  const factory StockEvent.deleteSupply(int id) = _DeleteSupply;
  const factory StockEvent.searchTransfers(int stockId, bool? initial) =
      _SearchTransfers;
  const factory StockEvent.downloadTransfers(int id) = _DownloadTransfers;
  const factory StockEvent.deleteTransfer(int id) = _DeleteTransfer;
  const factory StockEvent.searchWriteOffs(int stockId, bool? initial) =
      _SearchWriteOffs;
  const factory StockEvent.downloadWriteOffs(int id) = _DownloadWriteOffs;
  const factory StockEvent.deleteWriteOff(int id) = _DeleteWriteOff;
  const factory StockEvent.searchInventories(int stockId, bool? initial) =
      _SearchInventories;
  const factory StockEvent.downloadInventory(int id) = _DownloadInventory;
  const factory StockEvent.deleteInventory(int id) = _DeleteInventory;
  const factory StockEvent.selectedSupplier(int? id) = _SelectedSupplier;
  const factory StockEvent.toStockId(int? id) = _ToStockId;
  const factory StockEvent.dateFrom(DateTime dateFrom) = _dateFrom;
  const factory StockEvent.dateTo(DateTime dateTo) = _dateTo;
}
