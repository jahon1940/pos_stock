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
}
