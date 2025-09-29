import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/company_bonus_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/daos/company_dao.dart';
import 'package:hoomo_pos/data/sources/network/companies_api.dart';
import 'package:hoomo_pos/domain/repositories/companies.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CompaniesRepository)
class CompaniesRepositoryImpl implements CompaniesRepository {
  final CompaniesApi _companiesApi;
  final CompanyDao _companiesDao;

  CompaniesRepositoryImpl(this._companiesApi, this._companiesDao);

  @override
  Future<PaginatedDto<CompanyDto>> search(SearchRequest request) async {
    try {
      final response = await _companiesApi.search(request);

      // await _companiesDao.insertCompanies(
      //   response.results.map((e) => e.toCompany()).toList(),
      // );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(int, int)> synchronize(int page, {CancelToken? cancelToken}) async {
    try {
      final response = await _companiesApi.getCompanies(page, cancelToken: cancelToken);
      await _companiesDao.insertCompanies(response.results);
      return (response.pageNumber, response.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<Companies>> getLocalCompanies(int page) async {
    try {
      final res = await _companiesDao.getPaginatedItems(page: page);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CompanyDto> getCompany(int id) async {
    try {
      final res = await _companiesApi.getCompany(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<CompanyBonusDto>> getCompanyBonuses(SearchRequest request) async {
    try {
      final response = await _companiesApi.getCompanyBonuses(request);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
