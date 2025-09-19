import 'package:dio/dio.dart' show CancelToken;
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/exceptions/epos_exception.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';
import 'package:injectable/injectable.dart';

import 'epos_api.dart';

@Injectable(as: EposApi)
class EposApiImpl implements EposApi {
  final DioClient _dioClient;

  EposApiImpl(this._dioClient);

  @override
  Future<String> checkStatus() {
    // TODO: implement checkStatus
    throw UnimplementedError();
  }

  @override
  Future<String> closeZReport() async {
    try {
      final res = await _dioClient.postRequest(NetworkConstants.eposUrl, data: {
        "token": NetworkConstants.eposToken,
        "method": "closeZreport"
      });

      if (res['error']) {
        throw EposException(res['message']);
      }

      return res['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReceiptDto> fiscalOperation(
      ReceiptDto receipt, CancelToken? cancelToken) async {
    Map<String, dynamic> requestBody = cleanJson(receipt.toJson());

    requestBody.remove("receiptType");

    requestBody.addAll(
        {"token": NetworkConstants.eposToken, "method": receipt.receiptType});

    final response = await _dioClient.postRequest(
      NetworkConstants.eposUrl,
      data: requestBody,
      cancelToken: cancelToken,
    );

    if (response['error']) {
      throw EposException(response['message']);
    }

    Map<String, dynamic> info = response['info'];
    return receipt.copyWith(
      terminalId: info['terminalId'],
      receiptSeq: info['receiptSeq'],
      fiscalSign: info['fiscalSign'],
      qrCodeURL: info['qrCodeURL'],
      receiptType:
          receipt.receiptType == "saleEPS" ? "sale" : receipt.receiptType,
      receiptDateTime: info['dateTime'],
    );
  }

  @override
  Future<String> labelValidation(String mark) async {
    try {
      final res = await _dioClient.postRequest(NetworkConstants.eposUrl, data: {
        "token": NetworkConstants.eposToken,
        "method": "validationMarking",
        "marking": mark,
      });
      return res['cutMarking'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> openZReport() async {
    try {
      final res = await _dioClient.postRequest(NetworkConstants.eposUrl,
          data: {"token": NetworkConstants.eposToken, "method": "openZreport"});

      if (res['error']) {
        throw EposException(res['message']);
      }
      return res['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendReceipt() async {
    try {
      final res = await _dioClient.postRequest(NetworkConstants.eposUrl,
          data: {"token": NetworkConstants.eposToken, "method": "sendReceipt"});
      return res['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ZReportInfoDto> getZReportInfo() async {
    try {
      final res = await _dioClient.postRequest(NetworkConstants.eposUrl, data: {
        "token": NetworkConstants.eposToken,
        "method": "getZreportInfo",
        "printerSize": 80,
        "zReportId": 0
      }, converter: (response) {
        if (response['error']) {
          throw EposException(response['message']);
        }
        return ZReportInfoDto.fromJson(response['message']);
      });
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> cleanJson(Map<String, dynamic> json) {
    json.removeWhere((key, value) =>
        key == 'productId' || // Удаляем поле product_id
        value == null ||
        (value is String && value.isEmpty) ||
        (value is List && value.isEmpty) ||
        (value is Map && value.isEmpty));

    // Рекурсивно обрабатываем вложенные Map и List
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        json[key] = cleanJson(value);
      } else if (value is List) {
        json[key] = value
            .map((e) => e is Map<String, dynamic> ? cleanJson(e) : e)
            .where((e) => e != null)
            .toList();
      }
    });

    return json;
  }
}
