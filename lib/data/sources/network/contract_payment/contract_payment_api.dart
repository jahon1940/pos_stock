import 'package:hoomo_pos/data/dtos/contract_payment/contract_payment_dto.dart';

abstract class ContractPaymentApi {
  Future<List<ContractPaymentDto>> getPayments(int contractId);
}