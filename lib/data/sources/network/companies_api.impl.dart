import 'package:dio/dio.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/company_bonus_dto.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:injectable/injectable.dart';

import '../../../core/exceptions/server_exception.dart';
import '../../dtos/add_user/add_user_request.dart';
import 'companies_api.dart';

@Injectable(as: CompaniesApi)
class CompaniesApiImpl implements CompaniesApi {
  final DioClient _dioClient;

  CompaniesApiImpl(this._dioClient);

  @override
  Future<PaginatedDto<CompanyDto>> search(SearchRequest request) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<CompanyDto>>(
        NetworkConstants.searchCompanies,
        queryParameters: {"page": request.page, "page_size": 60},
        data: {"search": request.title},
        converter: (response) {
          return PaginatedDto.fromJson(
            response,
            (json) => CompanyDto.fromJson(json),
          );
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<Companies>> getCompanies(int page,
      {CancelToken? cancelToken}) async {
    try {
      final res = await _dioClient.getRequest<PaginatedDto<Companies>>(
          NetworkConstants.companies,
          queryParameters: {"page": page, "page_size": 100},
          converter: (response) => PaginatedDto.fromJson(
                response,
                (json) => Companies.fromJson(json),
              ),
          cancelToken: cancelToken);

      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CompanyDto> getCompany(int id, {CancelToken? cancelToken}) async {
    try {
      final res = await _dioClient.getRequest<CompanyDto>(
          "${NetworkConstants.companies}/$id",
          converter: (response) => CompanyDto.fromJson(response),
          cancelToken: cancelToken);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addSuppliers(AddUserRequest request) async {
    try {
      final result = await _dioClient.postRequest(
        NetworkConstants.addSuppliers,
        data: request,
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? "Server Error",
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<CompanyBonusDto>> getCompanyBonuses(SearchRequest request) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<CompanyBonusDto>>(
        NetworkConstants.searchCompanyBonuses,
        queryParameters: {"page": request.page, "page_size": 60},
        data: {"search": request.title},
        converter: (response) {
          return PaginatedDto.fromJson(
            response,
            (json) => CompanyBonusDto.fromJson(json),
          );
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
