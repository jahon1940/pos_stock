part of 'add_contractor_cubit.dart';

@freezed
class AddContractorState with _$AddContractorState {
  const factory AddContractorState({
    @Default(StateStatus.initial) StateStatus status,
    SupplierDto? supplier,
    List<SupplierDto>? suppliers,
  }) = _AddContractorState;
}
