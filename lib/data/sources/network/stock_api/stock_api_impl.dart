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
  Future<PaginatedDto<TransferDto>> searchTransfers(
    SearchTransfers request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<TransferDto>>(
        "${NetworkConstants.transfers}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => TransferDto.fromJson(json),
        ),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createTransfers(
    CreateTransfers request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.transfers,
        data: request.toJson(),
      );
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<TransferProductDto>> getTransfersProducts(
    int id,
  ) async {
    try {
      final res = await _dioClient.getRequest(
        '${NetworkConstants.transfers}/$id/products',
        converter: (response) => List.from(response['results']).map((e) => TransferProductDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTransfers(int id) async {
    try {
      await _dioClient.deleteRequest('${NetworkConstants.transfers}/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<WriteOffDto>> searchWriteOff(
    SearchWriteOff request,
  ) async {
    try {
      final res = await _dioClient.postRequest<PaginatedDto<WriteOffDto>>(
        "${NetworkConstants.writeOffs}/search",
        queryParameters: {"page": 1, "page_size": 200},
        data: request,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => WriteOffDto.fromJson(json),
        ),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createWriteOff(
    CreateWriteOff request,
  ) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.writeOffs,
        data: request.toJson(),
      );
      return res;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<WriteOffProductDto>> getWriteOffProducts(
    int id,
  ) async {
    try {
      final res = await _dioClient.getRequest(
        '${NetworkConstants.writeOffs}/$id/products',
        converter: (response) => List.from(response['results'])
            .map(
              (e) => WriteOffProductDto.fromJson(e),
            )
            .toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteWriteOff(
    int id,
  ) async {
    try {
      await _dioClient.deleteRequest('${NetworkConstants.writeOffs}/$id');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SupplyDto>?> getSupplies() async {
    try {
      final res = await _dioClient.getRequest(
        NetworkConstants.supplies,
        converter: (response) => List.from(response['results']).map((e) => SupplyDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<PaginatedDto<Supplies1C>?> getSupplies1C(SearchSupplies1C request) async {
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

  @override
  Future<void> downloadSupplies({
    required int id,
  }) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/поступление_$id.xlsx";
      await _dioClient.downloadRequest("${NetworkConstants.apiManagerUrl}/supplies/$id/download-excel", savePath);
    } catch (_) {}
  }

  @override
  Future<void> downloadTransfers({
    required int id,
  }) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/перемещение_$id.xlsx";
      await _dioClient.downloadRequest(
          "${NetworkConstants.apiManagerUrl}/stock-transfers/$id/download-excel", savePath);
    } catch (_) {}
  }

  @override
  Future<void> downloadWriteOffs({
    required int id,
  }) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/списание_товара_$id.xlsx";
      await _dioClient.downloadRequest("${NetworkConstants.apiManagerUrl}/write-offs/$id/download-excel", savePath);
    } catch (_) {}
  }
}
