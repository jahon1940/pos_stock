part of 'add_inventory_cubit.dart';

@freezed
class AddInventoryState with _$AddInventoryState {
  const factory AddInventoryState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<InventoryDto>? inventories,
    DateTime? dateFrom,
    DateTime? dateTo,
    CreateInventoryRequest? request,
    InventoryDto? inventory,
    List<InventoryProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _AddInventoryState;
}
