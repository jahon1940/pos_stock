import 'package:dio/dio.dart' show CancelToken;
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';

abstract class EposRepository {
  Future<String> checkStatus();

  Future<String> closeZReport();

  Future<ReceiptDto> fiscalOperation(ReceiptDto receipt, CancelToken? cancelToken);

  Future<String> labelValidation(String mark);

  Future<String> openZReport();

  Future<void> sendReceipt();

  Future<ZReportInfoDto> getZReportInfo();
}