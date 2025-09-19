part of 'contract_bloc.dart';

@freezed
class ContractState with _$ContractState {
  const factory ContractState({
    @Default(StateStatus.initial) StateStatus status,
    List<ContractDto>? contracts,
    PosManagerDto? posManagerDto,
    String? errorText
  }) = _ContractState;
}
