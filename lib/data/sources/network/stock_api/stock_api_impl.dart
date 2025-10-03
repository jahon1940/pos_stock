part of 'stock_api.dart';

@LazySingleton(as: StockApi)
class StockApiImpl implements StockApi {
  StockApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<StockDto>> getStocks(
    int organizationsId,
  ) async {
    try {
      final res = await _dioClient.getRequest(
        "${NetworkConstants.organizationsStock}/$organizationsId/stocks",
        converter: (response) => List.from(response['results']).map((e) => StockDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<Supplies1C>?> getSupplies1C(
    SearchSupplies1C request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        '${NetworkConstants.supplies1C}/search',
        data: request.toJson(),
        queryParameters: {"page": request.page, "page_size": 200},
        converter: (response) => PaginatedDto.fromJson(response, Supplies1C.fromJson),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> conductSupplies1C(
    SuppliesConduct request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.conduct,
        data: request.toJson(),
      );
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
      final res = await _dioClient.getRequest(
        "${NetworkConstants.supplies1C}/$id/products?page=1&page_size=200",
        converter: (response) => List.from(response['results'])
            .map(
              (e) => SupplyProductDto.fromJson(e),
            )
            .toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
