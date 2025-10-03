part of '../../domain/repositories/transfer_repository.dart';

@LazySingleton(as: TransferRepository)
class TransferRepositoryImpl implements TransferRepository {
  TransferRepositoryImpl(
    this._transferApi,
  );

  final TransferApi _transferApi;

  @override
  Future<PaginatedDto<TransferDto>> searchTransfers(
    SearchTransfers request,
  ) async {
    try {
      final res = await _transferApi.searchTransfers(request);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createTransfers(
    CreateTransfers request,
  ) async {
    try {
      final res = await _transferApi.createTransfers(request);
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
      final res = await _transferApi.getTransfersProducts(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTransfers(int id) async {
    try {
      final res = await _transferApi.deleteTransfers(id);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> downloadTransfers({
    required int id,
  }) async {
    try {
      await _transferApi.downloadTransfers(id: id);
    } catch (e) {
      rethrow;
    }
  }
}
