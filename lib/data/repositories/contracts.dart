import 'package:hoomo_pos/data/dtos/contract_dto.dart';
import 'package:hoomo_pos/data/sources/network/contracts_api.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/contracts.dart';

@LazySingleton(as: ContractsRepository)
class ContractsRepositoryImpl implements ContractsRepository {
  final ContractsApi _contractsApi;

  ContractsRepositoryImpl(this._contractsApi);

  @override
  Future<List<ContractDto>> getContracts(int companyId) async {
    try {
      return await _contractsApi.getContracts(companyId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createContract(String contractNum, String contractDate, int companyId) async {
    return await _contractsApi.createContract(contractNum, contractDate, companyId);
  }

  @override
  Future<void> updateContract(String contractNum, String contractDate, int companyId, int contractId) async{
    return await _contractsApi.updateContract(contractNum, contractDate, companyId, contractId);
  }
}
