import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/data/dtos/create_company/create_company_request.dart';
import 'package:hoomo_pos/data/sources/network/create_company/create_company_api.dart';
import 'package:hoomo_pos/domain/repositories/create_company.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CreateCompanyRepository)
class CreateCompanyRepositoryImpl implements CreateCompanyRepository {
  final CreateCompanyApi _companyApi;

  CreateCompanyRepositoryImpl(this._companyApi);

  @override
  Future<void> createCompany(CreateCompanyRequest request) async {
    return await _companyApi.createCompany(request);
  }

  @override
  Future<void> deleteCompany(int companyId) async{
    return await _companyApi.deleteCompany(companyId);
  }

  @override
  Future<CompanyDto?> getCompany(int companyId) async{
    return await _companyApi.getCompany(companyId);
  }

  @override
  Future<void> updateCompany(int companyId, CreateCompanyRequest request) async{
    return await _companyApi.updateCompany(companyId, request);
  }

}
