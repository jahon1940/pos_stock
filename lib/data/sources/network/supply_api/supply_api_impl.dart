part of 'supply_api.dart';

@LazySingleton(as: SupplyApi)
class StockApiImpl implements SupplyApi {
  StockApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<void> createSupply(
    CreateSupplyRequest request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.supplies,
        data: request.toJson(),
      );
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
      final res = await _dioClient.getRequest(
        '${NetworkConstants.supplies}/$id/products',
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

  @override
  Future<PaginatedDto<SupplyDto>> searchSupplies(
    SearchSupplies request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<SupplyDto>>(
        "${NetworkConstants.supplies}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => SupplyDto.fromJson(json),
        ),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSupply(
    int id,
  ) async {
    try {
      await _dioClient.deleteRequest('${NetworkConstants.supplies}/$id');
    } catch (e) {
      rethrow;
    }
  }
}
