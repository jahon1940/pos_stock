import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/create_reserve_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_request_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_response_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';

import '../../data/dtos/pagination_dto.dart';
import '../../data/dtos/receipts/receipts_search.dart';
import '../../data/dtos/reserve_dto.dart';
import '../../data/dtos/search_request.dart';
import '../../data/sources/app_database.dart';

abstract class ReceiptRepository {
  Future<ReceiptDto> sendReceipt(ReceiptDto receipt,
      {bool isFiscal = false, bool autoSend = false, CancelToken? cancelToken});

  Future<ReceiptDto> getReceipt(ReceiptDto receipt);

  Future<ReceiptDto?> getLocalReceipt(String id);

  Future<PaginatedDto<ReceiptDto>> getReceipts(
      {int page = 1, int itemsPerPage = 50});

  Future<PaginatedDto<ReceiptDto>?> getReceiptsRemote(
    SearchReceipts? request,
  );

  Future<PaginatedDto<ReceiptDto>> searchReceipt(SearchRequest searchRequest,
      {bool? isSynced});

  Future<List<ReceiptDto>> getUnSentReceipts();

  Future<int?> getOperationSum(String date, String type);

  Future<void> updateReceipt(Receipts receipt, String receiptId);

  Future<void> createReserve(CreateReserveDto reserve);

  Future<void> updateReserve(CreateReserveDto reserve);

  Future<void> deleteReserve(int reserveId);

  Future<void> realizationReserve(int reserveId);

  Future<List<ReserveDto>> getReserves();

  Future<void> downloadInvoice(int receiptId, int companyId, int contractId);

  Future<ZReportInfoDto> getPosReport();

  Future<List<ReceiptDto>> getReceiptsByDate(DateTime date);

  Future<CalculateKVIDiscountResponse> getDiscount(
      CalculateKVIDiscountRequest data);

  /// Retry sending unsynchronized receipts to server
  Future<void> retrySendUnSyncedReceipts();

  /// Send single receipt with retry mechanism
  Future<ReceiptDto> retrySendReceipt(ReceiptDto receipt);

  /// Update whole receipt after synchronization with server
  Future<void> updateReceiptFromServer(
      ReceiptDto serverReceipt, String localReceiptId);
}
