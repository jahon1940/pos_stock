part of 'write_off_api.dart';

@LazySingleton(as: WriteOffApi)
class WriteOffApiImpl implements WriteOffApi {
  WriteOffApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

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
