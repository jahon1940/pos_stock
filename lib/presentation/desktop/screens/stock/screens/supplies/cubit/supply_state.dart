part of 'supply_cubit.dart';

@freezed
class SupplyState with _$SupplyState {
  const factory SupplyState({
    @Default(StateStatus.initial) StateStatus status,
    CreateSupplyRequest? request,
    @Default(<SupplierDto>[]) List<SupplierDto> suppliers,
    SupplyDto? supply,
    PaginatedDto<SupplyDto>? supplies,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? supplierId,
    List<SupplyProductDto>? products,
    @Default(false) bool isActivaBtn,
  }) = _SupplyState;
}
