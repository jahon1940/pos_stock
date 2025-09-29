part of '../../domain/repositories/supplier_repository.dart';

@LazySingleton(as: SupplierRepository)
class SupplierRepositoryImpl implements SupplierRepository {
  SupplierRepositoryImpl(
    this._supplierApi,
  );

  final SupplierApi _supplierApi;

  @override
  Future<void> createSupplier(
    SupplierDto supplier,
  ) async {
    try {
      await _supplierApi.createSupplier(supplier);
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteSupplier(
    int supplierId,
  ) async {
    try {
      await _supplierApi.deleteSupplier(supplierId);
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<List<SupplierDto>?> getSuppliers() async {
    try {
      List<SupplierDto>? suppliers = await _supplierApi.getSuppliers();
      return suppliers;
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> updateSupplier(
    SupplierDto supplier,
  ) async {
    try {
      await _supplierApi.updateSupplier(supplier);
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error", ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }
}
