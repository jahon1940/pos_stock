import 'package:hoomo_pos/data/dtos/contract_payment/contract_payment_dto.dart';
import 'package:hoomo_pos/data/sources/network/contract_payment/contract_payment_api.dart';
import 'package:hoomo_pos/domain/repositories/contract_payment.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ContractPaymentRepository)
class ContractPaymentRepositoryIml implements ContractPaymentRepository {
  final ContractPaymentApi _contractPaymentApi;

  ContractPaymentRepositoryIml(this._contractPaymentApi);

  @override
  Future<List<ContractPaymentDto>> getPayments(int contractId) async{
   return await _contractPaymentApi.getPayments(contractId);
  }
}