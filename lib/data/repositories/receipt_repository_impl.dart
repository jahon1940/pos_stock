import 'package:dio/dio.dart' show CancelToken;
import 'package:hoomo_pos/data/dtos/create_reserve_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_request_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_response_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/reserve_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/daos/receipt_dao.dart';
import 'package:hoomo_pos/data/sources/network/receipt/receipt_api.dart';
import 'package:hoomo_pos/domain/repositories/epos_repository.dart';
import 'package:hoomo_pos/domain/repositories/receipt_repository.dart';
import 'package:injectable/injectable.dart';

import '../dtos/receipts/receipts_search.dart';

@LazySingleton(as: ReceiptRepository)
class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptApi _receiptApi;
  final ReceiptsDao _receiptsDao;
  final EposRepository _eposRepository;

  ReceiptRepositoryImpl(
    this._receiptApi,
    this._eposRepository,
    this._receiptsDao,
  );

  @override
  Future<ReceiptDto> sendReceipt(ReceiptDto receipt,
      {bool isFiscal = false, bool autoSend = false, CancelToken? cancelToken}) async {
    String? receiptId = receipt.id;
    ReceiptDto processedReceipt = receipt;
    String finalReceiptId = DateTime.now().millisecondsSinceEpoch.toString();
    bool fiscalOperationCompleted = false;

    try {
      final price = receipt.params.items.map((item) => item.price).reduce((value, element) => value + element);

      final other =
          receipt.params.items.map((item) => item.other).reduce((value, element) => (value ?? 0) + (element ?? 0));

      final payByDiscount = (other ?? 0) >= price || (receipt.paymentTypes?.any((e) => e.name == 'Ваучер') ?? false);

      if (payByDiscount) {
        processedReceipt = processedReceipt.copyWith(sendSoliq: false);
      }

      // Step 1: Fiscal Operation (if required and not already completed)
      if (isFiscal && !autoSend && !payByDiscount && !fiscalOperationCompleted) {
        processedReceipt = await _eposRepository.fiscalOperation(processedReceipt.copyWith(id: null), cancelToken);
        fiscalOperationCompleted = true;

        // Ensure we have a valid receipt ID after fiscal operation
        processedReceipt = processedReceipt.copyWith(id: finalReceiptId);

        // Step 2: Save locally immediately after fiscal operation
        if (!autoSend) {
          await _receiptsDao.addReceipt(processedReceipt.copyWith(isSynced: false).toReceipt());
        }
      }

      // Step 3: Attempt to send to server
      try {
        processedReceipt = await _receiptApi.sendReceipt(processedReceipt.copyWith(id: null));
        processedReceipt = processedReceipt.copyWith(isSynced: true);

        updateReceipt(processedReceipt.copyWith(id: finalReceiptId).toReceipt(), processedReceipt.id.toString());
      } catch (serverError) {
        // Server failed, but fiscal operation succeeded - keep receipt locally
        processedReceipt = processedReceipt.copyWith(isSynced: false);

        // If we haven't saved yet (non-fiscal receipts), save now
        await _receiptsDao.updateReceiptSyncStatus(processedReceipt.id ?? receiptId ?? '', false);

        // Re-throw server error so the UI knows about it
        rethrow;
      }

      return processedReceipt;
    } catch (e) {
      // If fiscal operation failed and we haven't saved yet, save with error state
      if (!autoSend && processedReceipt.id == null) {
        processedReceipt = processedReceipt.copyWith(isSynced: false);
        await _receiptsDao.addReceipt(processedReceipt.toReceipt());
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ReceiptDto>> getReceipts({int page = 1, int itemsPerPage = 50}) async {
    // Получаем пагинированные данные
    final paginatedReceipts = await _receiptsDao.getPaginatedReceipts(
      page: page,
      itemsPerPage: itemsPerPage,
    );

    // Преобразуем результаты в список ReceiptDto и возвращаем PaginatedDto
    return PaginatedDto<ReceiptDto>(
      results: paginatedReceipts.results.map((receipt) => ReceiptDto.toDto(receipt)).toList(),
      pageNumber: paginatedReceipts.pageNumber,
      pageSize: paginatedReceipts.pageSize,
      totalPages: paginatedReceipts.totalPages,
      count: paginatedReceipts.count,
    );
  }

  @override
  Future<PaginatedDto<ReceiptDto>> searchReceipt(
    SearchRequest searchRequest, {
    bool? isSynced,
  }) async {
    final paginatedReceipts = await _receiptsDao.searchPaginatedReceipts(
      searchRequest: searchRequest,
      isSynced: isSynced,
    );
    return paginatedReceipts;
  }

  @override
  Future<int?> getOperationSum(String date, String type) async {
    return _receiptsDao.getTotalReceivedCashFromDateToNow(
      fromDate: date,
      receiptType: type,
    );
  }

  @override
  Future<ReceiptDto> getReceipt(ReceiptDto receipt) async {
    return _receiptApi.getReceipt(receipt);
  }

  @override
  Future<List<ReceiptDto>> getUnSentReceipts() async {
    return _receiptsDao.getUnSyncedReceipts();
  }

  @override
  Future<void> updateReceipt(Receipts receipt, String receiptId) async {
    await _receiptsDao.replaceReceiptId(receipt, receiptId);
  }

  @override
  Future<PaginatedDto<ReceiptDto>?> getReceiptsRemote(
    SearchReceipts? request,
  ) async {
    return _receiptApi.getReceiptsRemote(request);
  }

  @override
  Future<ReceiptDto?> getLocalReceipt(String id) async {
    return _receiptsDao.getReceipt(int.parse(id));
  }

  @override
  Future<void> createReserve(CreateReserveDto reserve) async {
    return _receiptApi.createReserve(reserve);
  }

  @override
  Future<List<ReserveDto>> getReserves() async {
    return _receiptApi.getReserves();
  }

  @override
  Future<void> realizationReserve(int reserveId) async {
    return _receiptApi.realizationReserve(reserveId);
  }

  @override
  Future<void> deleteReserve(int reserveId) async {
    return _receiptApi.deleteReserve(reserveId);
  }

  @override
  Future<void> downloadInvoice(
    int receiptId,
    int companyId,
    int contractId,
  ) async {
    await _receiptApi.downloadInvoice(receiptId, companyId, contractId);
  }

  @override
  Future<ZReportInfoDto> getPosReport() async {
    return _receiptApi.getReportInfo();
  }

  @override
  Future<void> updateReserve(CreateReserveDto reserve) async {
    return _receiptApi.updateReserve(reserve);
  }

  @override
  Future<List<ReceiptDto>> getReceiptsByDate(DateTime date) async {
    return _receiptsDao.getReceiptsByDate(date);
  }

  @override
  Future<CalculateKVIDiscountResponse> getDiscount(CalculateKVIDiscountRequest data) async {
    return _receiptApi.getDiscount(data);
  }

  @override
  Future<void> retrySendUnSyncedReceipts() async {
    try {
      final unSyncedReceipts = await getUnSentReceipts();

      for (final receipt in unSyncedReceipts) {
        try {
          // Attempt to send receipt to server
          final updatedReceipt = await retrySendReceipt(receipt);

          // Update whole receipt with server data, keeping local ID
          await updateReceiptFromServer(updatedReceipt, receipt.id ?? '');
        } catch (e) {
          // Log individual receipt send failure but continue with others
          print('Failed to sync receipt ${receipt.id}: $e');
          continue;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReceiptDto> retrySendReceipt(ReceiptDto receipt) async {
    try {
      // Attempt to send to server
      final updatedReceipt = await _receiptApi.sendReceipt(receipt);

      // Update whole receipt with server data and replace local ID with server ID
      await updateReceiptFromServer(updatedReceipt, receipt.id!);

      return updatedReceipt.copyWith(isSynced: true);
    } catch (e) {
      // Keep local receipt but mark as failed
      await _receiptsDao.updateReceiptSyncStatus(receipt.id!, false);
      rethrow;
    }
  }

  /// Update whole receipt after synchronization with server
  Future<void> updateReceiptFromServer(ReceiptDto serverReceipt, String localReceiptId) async {
    try {
      // Get the local receipt
      final localReceipt = await getLocalReceipt(localReceiptId);
      if (localReceipt == null) {
        throw Exception('Local receipt not found');
      }

      // Use server receipt data with server ID and mark as synced
      final updatedReceipt = serverReceipt.copyWith(isSynced: true);

      // Replace local receipt with server receipt using replaceReceiptId
      await _receiptsDao.replaceReceiptId(localReceipt.toReceipt(), updatedReceipt.id ?? '');
    } catch (e) {
      // If update fails, just update sync status as fallback
      await _receiptsDao.updateReceiptSyncStatus(localReceiptId, true);
    }
  }
}
