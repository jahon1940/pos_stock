part of '../../domain/repositories/supply_repository.dart';

@LazySingleton(as: SupplyRepository)
class SupplyRepositoryImpl implements SupplyRepository {
  SupplyRepositoryImpl(
    this._supplyApi,
  );

  final SupplyApi _supplyApi;

  @override
  Future<void> createSupply(
    CreateSupplyRequest request,
  ) async {
    try {
      final res = await _supplyApi.createSupply(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<SupplyProductDto>> getSupplyProducts(
    int id,
  ) async {
    try {
      final res = await _supplyApi.getSupplyProducts(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<SupplyDto>> searchSupplies(
    SearchSupplies request,
  ) async {
    try {
      final res = await _supplyApi.searchSupplies(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteSupply(int id) async {
    try {
      final res = await _supplyApi.deleteSupply(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadSupplies({
    required int id,
  }) async {
    try {
      await _supplyApi.downloadSupplies(id: id);
    } catch (e) {
      rethrow;
    }
  }
}
