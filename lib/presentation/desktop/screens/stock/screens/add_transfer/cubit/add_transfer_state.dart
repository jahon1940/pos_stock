part of 'add_transfer_cubit.dart';

@freezed
class AddTransferState with _$AddTransferState {
  const factory AddTransferState({
    @Default(StateStatus.initial) StateStatus status,
    CreateTransfers? request,
    TransferDto? transfer,
    @Default(<StockDto>[]) List<StockDto> stocks,
    StockDto? stock,
    List<TransferProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _AddTransferState;
}
