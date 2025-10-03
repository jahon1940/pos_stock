part of '../../domain/repositories/stock_repository.dart';

@LazySingleton(as: StockRepository)
class StockRepositoryImpl implements StockRepository {
  StockRepositoryImpl(
    this._stockApi,
  );

  final StockApi _stockApi;

  @override
  Future<List<StockDto>?> getStocks(
    int organizationsId,
  ) async {
    try {
      final res = await _stockApi.getStocks(organizationsId);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<PaginatedDto<Supplies1C>?> getSupplies1C(
    SearchSupplies1C request,
  ) async {
    try {
      final res = await _stockApi.getSupplies1C(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<void> conductSupplies1C(
    SuppliesConduct request,
  ) async {
    try {
      final res = await _stockApi.conductSupplies1C(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<SupplyProductDto>> getSupply1CProducts(
    int id,
  ) async {
    try {
      final res = await _stockApi.getSupply1CProducts(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
