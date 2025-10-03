part of 'inventory_api.dart';

@LazySingleton(as: InventoryApi)
class InventoryImpl implements InventoryApi {
  InventoryImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<PaginatedDto<InventoryDto>> searchInventory(
    SearchInventories request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<InventoryDto>>(
        "${NetworkConstants.inventories}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) {
          return PaginatedDto.fromJson(
            response,
            (json) => InventoryDto.fromJson(json),
          );
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createInventory(
    CreateInventoryRequest request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.inventories,
        data: request.toJson(),
      );
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<InventoryProductDto>> getInventoryProducts(
    int id,
  ) async {
    try {
      final res = await _dioClient.getRequest(
        '${NetworkConstants.inventories}/$id/products',
        converter: (response) => List.from(response['results'])
            .map(
              (e) => InventoryProductDto.fromJson(e),
            )
            .toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteInventory(
    int id,
  ) async {
    try {
      await _dioClient.deleteRequest('${NetworkConstants.inventories}/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadInventories({
    required int id,
  }) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/инвенторизация_$id.xlsx";
      await _dioClient.downloadRequest("${NetworkConstants.apiManagerUrl}/inventories/$id/download-excel", savePath);
    } catch (_) {}
  }
}
