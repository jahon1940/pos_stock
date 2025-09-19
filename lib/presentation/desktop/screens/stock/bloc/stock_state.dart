part of 'stock_bloc.dart';

@freezed
class StockState with _$StockState {
  const factory StockState({
    @Default(StateStatus.initial) StateStatus status,
    @Default(<CompanyDto>[]) List<CompanyDto> organizations,
    @Default(<StockDto>[]) List<StockDto> stocks,
    PaginatedDto<SupplyDto>? supplies,
    PaginatedDto<TransferDto>? transfers,
    PaginatedDto<WriteOffDto>? writeOffs,
    PaginatedDto<InventoryDto>? inventories,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? supplierId,
  }) = _StockState;
}
