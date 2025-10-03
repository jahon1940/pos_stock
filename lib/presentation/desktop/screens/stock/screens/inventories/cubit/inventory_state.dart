part of 'inventory_cubit.dart';

@freezed
class InventoryState with _$InventoryState {
  const factory InventoryState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<InventoryDto>? inventories,
    DateTime? dateFrom,
    DateTime? dateTo,
    CreateInventoryRequest? request,
    InventoryDto? inventory,
    List<InventoryProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _InventoryState;
}
