import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/contract_payment/contract_payment_dto.dart';
import 'package:injectable/injectable.dart';

import 'contract_payment_api.dart';

@LazySingleton(as: ContractPaymentApi)
class ContractPaymentApiImpl implements ContractPaymentApi{
  final DioClient _dioClient;

  ContractPaymentApiImpl(this._dioClient);

  @override
  Future<List<ContractPaymentDto>> getPayments(int contractId) async {
    final res = await _dioClient.getRequest<List<ContractPaymentDto>>(
      "${NetworkConstants.contracts}/$contractId/payments",
      converter: (response) {
        try {
          final List<dynamic> jsonList = response['results'] as List<dynamic>;
          return jsonList.map((json) => ContractPaymentDto.fromJson(json)).toList();
        } catch(ex, s) {
          print(ex);
          print(s);
          rethrow;
        }
      },
    );
    return res;
  }
}