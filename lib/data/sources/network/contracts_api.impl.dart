import 'package:dio/dio.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/exceptions/server_exception.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/contract_dto.dart';
import 'package:injectable/injectable.dart';

import 'contracts_api.dart';

@Injectable(as: ContractsApi)
class ContractsApiImpl implements ContractsApi {
  final DioClient _dioClient;

  ContractsApiImpl(this._dioClient);

  @override
  Future<List<ContractDto>> getContracts(int companyId) async {
    try {
      final res = await _dioClient.getRequest<List<ContractDto>>(
        "${NetworkConstants.companies}/$companyId/contracts",
        converter: (response) {
          try {
            final List<dynamic> jsonList = response['results'] as List<dynamic>;
            return jsonList.map((json) => ContractDto.fromJson(json)).toList();
          } catch(ex, s) {
            print(ex);
            print(s);
            rethrow;
          }
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createContract(String contractNum, String contractDate, int companyId) async{
    try {
      await _dioClient.postRequest<List<ContractDto>>(
        NetworkConstants.contracts,
        data: {
          "company_id": companyId,
          "date": contractDate,
          "number": contractNum
        }
      );
    } catch (e) {
      if(e is DioException) {
        throw ServerException(e.response?.data['message'] ?? "Ошибка обработки запроса", e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> updateContract(String contractNum, String contractDate, int companyId, int contractId) async {
    try {
      await _dioClient.putRequest(
          "${NetworkConstants.contracts}/$contractId",
          data: {
            "company_id": companyId,
            "date": contractDate,
            "number": contractNum
          }
      );
    } catch (e) {
      if(e is DioException) {
        throw ServerException(e.response?.data['message'] ?? "Ошибка обработки запроса", e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }
}
