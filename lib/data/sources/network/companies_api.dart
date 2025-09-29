import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/company_bonus_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

abstract class CompaniesApi {
  Future<PaginatedDto<CompanyDto>> search(SearchRequest request);

  Future<PaginatedDto<Companies>> getCompanies(int page, {CancelToken? cancelToken});

  Future<CompanyDto> getCompany(int id, {CancelToken? cancelToken});

  Future<PaginatedDto<CompanyBonusDto>> getCompanyBonuses(SearchRequest request);
}
