import 'package:dio/dio.dart';
import 'package:hoomo_pos/core/exceptions/server_exception.dart';
import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';
import 'package:hoomo_pos/data/sources/network/manager_api/manager_api.dart';
import 'package:hoomo_pos/domain/repositories/manager_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ManagerRepository)
class ManagerRepositoryImpl implements ManagerRepository {
  final ManagerApi _managerApi;

  ManagerRepositoryImpl(this._managerApi);

  @override
  Future<void> createManager(
    ManagerDto manager,
  ) async {
    try {
      await _managerApi.createManager(manager);
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteManager(
    String managerId,
  ) async {
    try {
      await _managerApi.deleteManager(managerId);
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<List<ManagerDto>?> getManagers() async {
    try {
      List<ManagerDto>? managers = await _managerApi.getManagers();
      return managers;
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> updateManager(
    ManagerDto manager,
  ) async {
    try {
      await _managerApi.updateManager(manager);
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }
}
