part of 'supplier_cubit.dart';

@freezed
class SupplierState with _$SupplierState {
  const factory SupplierState({
    @Default(StateStatus.initial) StateStatus status,
    SupplierDto? supplier,
    List<SupplierDto>? suppliers,
  }) = _SupplierState;
}
