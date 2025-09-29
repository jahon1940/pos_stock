import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/create_company/create_company_request.dart';
import 'package:injectable/injectable.dart';

import 'create_company_api.dart';


@LazySingleton(as: CreateCompanyApi)
class CreateCompanyApiImpl extends CreateCompanyApi {
  final DioClient _dioClient;

  CreateCompanyApiImpl(this._dioClient);

  @override
  Future<void> createCompany(CreateCompanyRequest request) async {
    await _dioClient.postRequest(NetworkConstants.companies, data: request.toJson());
  }

  @override
  Future<void> deleteCompany(int companyId) async{
    await _dioClient.deleteRequest("${NetworkConstants.companies}/$companyId");
  }

  @override
  Future<CompanyDto?> getCompany(int companyId) async {
    final res = await _dioClient.getRequest(
      "${NetworkConstants.companies}/$companyId",
      converter: (response) => CompanyDto.fromJson(response),
    );
    return res;
  }

  @override
  Future<void> updateCompany(int companyId, CreateCompanyRequest request) async {
    await _dioClient.putRequest("${NetworkConstants.companies}/$companyId", data: request.toJson());
  }
}