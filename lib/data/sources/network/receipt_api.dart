import 'package:hoomo_pos/data/dtos/kvi_discount_request_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_response_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/reserve_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';

import '../../dtos/create_reserve_dto.dart';
import '../../dtos/pagination_dto.dart';
import '../../dtos/receipts/receipts_search.dart';

abstract class ReceiptApi {
  Future<ReceiptDto> sendReceipt(ReceiptDto receipt);
  Future<ReceiptDto> getReceipt(ReceiptDto receipt);
  Future<PaginatedDto<ReceiptDto>?> getReceiptsRemote(SearchReceipts? request);
  Future<void> createReserve(CreateReserveDto reserve);
  Future<void> updateReserve(CreateReserveDto reserve);
  Future<void> realizationReserve(int reserveId);
  Future<void> downloadInvoice(int receiptId, int companyId, int contractId);
  Future<void> deleteReserve(int reserveId);
  Future<List<ReserveDto>> getReserves();
  Future<ZReportInfoDto> getReportInfo();
  Future<CalculateKVIDiscountResponse> getDiscount(CalculateKVIDiscountRequest data);
}
