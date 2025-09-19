import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/data/dtos/create_company/create_company_request.dart';

abstract class CreateCompanyRepository {
  Future<CompanyDto?> getCompany(int companyId);

  Future<void> createCompany(CreateCompanyRequest request);

  Future<void> updateCompany(int companyId, CreateCompanyRequest request);

  Future<void> deleteCompany(int companyId);
}