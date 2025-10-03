part of '../../domain/repositories/write_off_repository.dart';

@LazySingleton(as: WriteOffRepository)
class WriteOffRepositoryImpl implements WriteOffRepository {
  WriteOffRepositoryImpl(
    this._writeOffApi,
  );

  final WriteOffApi _writeOffApi;

  @override
  Future<PaginatedDto<WriteOffDto>> searchWriteOff(
    SearchWriteOff request,
  ) async {
    try {
      final res = await _writeOffApi.searchWriteOff(request);

      return res;
    } catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  @override
  Future<void> createWriteOff(
    CreateWriteOff request,
  ) async {
    try {
      final res = await _writeOffApi.createWriteOff(request);
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
      final res = await _writeOffApi.getWriteOffProducts(id);
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
      final res = await _writeOffApi.deleteWriteOff(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadWriteOffs({
    required int id,
  }) async {
    try {
      await _writeOffApi.downloadWriteOffs(id: id);
    } catch (e) {
      rethrow;
    }
  }
}
