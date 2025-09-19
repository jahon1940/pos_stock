import 'package:hoomo_pos/data/dtos/contract_dto.dart';

abstract class ContractsRepository {
  Future<List<ContractDto>> getContracts(int companyId);
  Future<void> createContract(String contractNum, String contractDate, int companyId);
  Future<void> updateContract(String contractNum, String contractDate, int companyId, int contractId);
}
