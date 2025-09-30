part of 'add_supplies_cubit.dart';

@freezed
class AddSuppliesState with _$AddSuppliesState {
  const factory AddSuppliesState({
    @Default(StateStatus.initial) StateStatus status,
    CreateSupplyRequest? request,
    @Default(<SupplierDto>[]) List<SupplierDto> suppliers,
    SupplyDto? supply,
    List<SupplyProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _AddSuppliesState;
}
