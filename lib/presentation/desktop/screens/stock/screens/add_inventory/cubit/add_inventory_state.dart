part of 'add_inventory_cubit.dart';

@freezed
class AddInventoryState with _$AddInventoryState {
  const factory AddInventoryState({
    @Default(StateStatus.initial) StateStatus status,
    CreateInventoryRequest? request,
    InventoryDto? Inventory,
    List<InventoryProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _AddInventoryState;
}
