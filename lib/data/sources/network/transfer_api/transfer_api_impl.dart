part of 'transfer_api.dart';

@LazySingleton(as: TransferApi)
class TransferApiImpl implements TransferApi {
  TransferApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

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
}
