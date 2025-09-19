part of 'contract_payment_cubit.dart';

@freezed
class ContractPaymentState with _$ContractPaymentState {
  const factory ContractPaymentState({
    @Default(StateStatus.initial) StateStatus status,
    List<ContractPaymentDto>? payments,
  }) = _ContractPaymentState;
}
