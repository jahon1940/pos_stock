part of '../../domain/repositories/manager_repository.dart';

@LazySingleton(as: ManagerRepository)
class ManagerRepositoryImpl implements ManagerRepository {
  ManagerRepositoryImpl(
    this._managerApi,
  );

  final ManagerApi _managerApi;

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
