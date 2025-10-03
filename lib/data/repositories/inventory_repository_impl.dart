part of '../../domain/repositories/inventory_repository.dart';

@LazySingleton(as: InventoryRepository)
class StockRepositoryImpl implements InventoryRepository {
  StockRepositoryImpl(
    this._inventoryApi,
  );

  final InventoryApi _inventoryApi;

  @override
  Future<PaginatedDto<InventoryDto>> searchInventory(
    SearchInventories request,
  ) async {
    try {
      final res = await _inventoryApi.searchInventory(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  @override
  Future<void> createInventory(
    CreateInventoryRequest request,
  ) async {
    try {
      final res = await _inventoryApi.createInventory(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<InventoryProductDto>> getInventoryProducts(
    int id,
  ) async {
    try {
      final res = await _inventoryApi.getInventoryProducts(id);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteInventory(int id) async {
    try {
      final res = await _inventoryApi.deleteInventory(id);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> downloadInventories({
    required int id,
  }) async {
    try {
      await _inventoryApi.downloadInventories(id: id);
    } catch (e) {
      rethrow;
    }
  }
}
