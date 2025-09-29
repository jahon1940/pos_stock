import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/company_bonus_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

abstract class CompaniesRepository {
  Future<PaginatedDto<CompanyDto>> search(SearchRequest request);

  Future<(int, int)> synchronize(int page, {CancelToken? cancelToken});

  Future<PaginatedDto<Companies>> getLocalCompanies(int page);

  Future<CompanyDto> getCompany(int id);

  Future<PaginatedDto<CompanyBonusDto>> getCompanyBonuses(SearchRequest request);
}
