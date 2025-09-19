part of 'contract_bloc.dart';

abstract class ContractEvent {}

class ContractLoad extends ContractEvent {
  final int companyId;
  ContractLoad(this.companyId);
}

class CreateContractEvent extends ContractEvent {
  final String contractNum;
  final String contractDate;
  final int companyId;
  final int? contractId;
  CreateContractEvent(this.contractNum, this.contractDate, this.companyId, this.contractId);
}
