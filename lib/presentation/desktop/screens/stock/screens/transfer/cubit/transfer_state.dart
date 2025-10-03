part of 'transfer_cubit.dart';

@freezed
class TransferState with _$TransferState {
  const factory TransferState({
    @Default(StateStatus.initial) StateStatus status,
    CreateTransfers? request,
    TransferDto? transfer,
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default(<StockDto>[]) List<StockDto> stocks,
    StockDto? stock,
    List<TransferProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _TransferState;
}
