import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/exceptions/server_exception.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/epos_product_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_request_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_response_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_params_dto.dart';
import 'package:hoomo_pos/data/dtos/reserve_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:injectable/injectable.dart' show Injectable;
import 'package:intl/intl.dart' show DateFormat;

import '../../../../domain/repositories/pos_manager_repository.dart';
import '../../../dtos/create_reserve_dto.dart';
import '../../../dtos/pagination_dto.dart';
import '../../../dtos/receipts/receipts_search.dart';

part 'receipt_api.impl.dart';

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
