import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/exceptions/server_exception.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/create_reserve_dto.dart';
import 'package:hoomo_pos/data/dtos/epos_product_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_request_dto.dart';
import 'package:hoomo_pos/data/dtos/kvi_discount_response_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_params_dto.dart';
import 'package:hoomo_pos/data/dtos/reserve_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';
import 'package:hoomo_pos/data/sources/network/receipt_api.dart';
import 'package:hoomo_pos/domain/repositories/pos_manager.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:injectable/injectable.dart';

import '../../dtos/pagination_dto.dart';
import '../../dtos/receipts/receipts_search.dart';

@Injectable(as: ReceiptApi)
class ReceiptApiImpl implements ReceiptApi {
  final DioClient _dioClient;
  final PosManagerRepository posManagerRepository;

  ReceiptApiImpl(this._dioClient, this.posManagerRepository);

  @override
  Future<ReceiptDto> sendReceipt(ReceiptDto receipt) async {
    try {
      final response = await _dioClient.postRequest(
        NetworkConstants.posReceipt,
        data: toPosJson(receipt),
      );
      return receipt.copyWith(
          id: response["id"].toString(),
          isSynced: true,
          receiptSeq: (receipt.receiptSeq == "0" ||
                  receipt.receiptSeq == null ||
                  (receipt.receiptSeq?.isEmpty ?? false))
              ? response["id"].toString()
              : receipt.receiptSeq,
          receiptDateTime: (receipt.receiptDateTime == null ||
                  (receipt.receiptDateTime?.isEmpty ?? false))
              ? FormatterService().datePosParser(response["datetime"])
              : receipt.receiptDateTime);
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? "Server Error",
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  Map<String, dynamic> toPosJson(ReceiptDto receipt) => {
        "id": receipt.id,
        "company_name": receipt.companyName,
        "company_address": receipt.companyAddress,
        "company_inn": receipt.companyINN,
        "receipt_type": receipt.receiptType,
        "staff_name": receipt.staffName,
        "printer_size": receipt.printerSize,
        "phone_number": receipt.phoneNumber,
        "company_phone_number": receipt.companyPhoneNumber,
        "terminal_id": receipt.terminalId,
        "receipt_seq": receipt.receiptSeq,
        "fiscal_sign": receipt.fiscalSign,
        "qr_code_url": receipt.qrCodeURL,
        "datetime":
            FormatterService().datePosFormatter(receipt.receiptDateTime),
        "close_time": FormatterService().datePosFormatter(receipt.closeTime),
        "paycheck": receipt.paycheck,
        "paycheck_number": receipt.params.paycheckNumber,
        "payment_number": receipt.params.paymentNumber,
        "note": receipt.params.note,
        "client_name": receipt.params.clientName,
        "state_duty": receipt.params.stateDuty,
        "fine_amount": receipt.params.fineAmount,
        "contract_sum": receipt.params.contractSum,
        "received_cash": receipt.params.receivedCash,
        "received_card": receipt.params.receivedCard,
        "refund_cash": receipt.params.refundCash,
        "refund_card": receipt.params.refundCard,
        "received_vat": receipt.params.receivedVat,
        "refund_vat": receipt.params.refundVat,
        "sales_count": receipt.params.salesCount,
        "refunds_count": receipt.params.refundsCount,
        "card_number": receipt.cardNumber,
        "send_soliq": receipt.sendSoliq,
        "order_id": receipt.orderId,
        "sale_manager_id": receipt.saleManagerId,
        "received_dollar": receipt.params.receivedDollar,
        "refund_info": receipt.refundInfo != null
            ? {
                "receipt_seq": receipt.refundInfo?.receiptSeq,
                "fiscal_sign": receipt.refundInfo?.fiscalSign,
                "terminal_id": receipt.refundInfo?.terminalId,
                "receipt_id": receipt.refundInfo?.receiptId,
              }
            : null,
        "is_corporate_client": receipt.extraInfo?.cardType == 1,
        "payments": receipt.paymentTypes
            ?.map((e) => {
                  "payment_type_id": e.id,
                  "price": e.price,
                })
            .toList(),
        "items": receipt.params.items
            .map((e) => {
                  "product_id": int.parse(e.productId ?? "0"),
                  "name": e.name,
                  "quantity": e.amount,
                  "price": (e.price - (e.discount ?? 0)).toInt(),
                  "discount": e.discount,
                  "vat_percent": e.vatPercent,
                  "vat": e.vat,
                  "owner_type": e.ownerType,
                  "class_code": e.classCode,
                  "package_code": e.packageCode,
                  "label": e.label,
                  "commission_tin": e.commissionTIN
                })
            .toList(),
        "extra_info": receipt.extraInfo?.toJson(),
      };

  @override
  Future<ReceiptDto> getReceipt(ReceiptDto receipt) async {
    try {
      final response = await _dioClient.getRequest(
        "${NetworkConstants.posReceipt}/${receipt.id}",
      );
      return receipt.copyWith(
          id: response["id"].toString(),
          isSynced: true,
          sendTo1C: response['sent_to_1c'],
          error1C: response['error_1c'],
          receiptSeq: response['receipt_seq'],
          terminalId: response['terminal_id'],
          params: receipt.params.copyWith(
              receivedDollar: (response['received_dollar'] ?? 0).toInt()));
    } catch (e, s) {
      print(e);
      print(s);
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? "Server Error",
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ReceiptDto>?> getReceiptsRemote(
    SearchReceipts? request,
  ) async {
    try {
      PosManagerDto posManagerDto = await posManagerRepository.getPosManager();

      final page = request?.page ?? 1;
      final response = await _dioClient.postRequest(
        "${NetworkConstants.posReceipt}/search?page=$page&page_size=40",
        data: request,
        converter: (response) {
          try {
            return PaginatedDto.fromJson(
              response,
              (json) => ReceiptDto(
                  id: json['id'].toString(),
                  companyName:
                      posManagerDto.pos?.stock?.organization?.name ?? "",
                  companyAddress: posManagerDto.pos?.stock?.address ?? "",
                  companyINN: posManagerDto.pos?.stock?.organization?.inn ?? "",
                  receiptType: json['receipt_type'],
                  saleManagerId: json['sale_manager_id'],
                  staffName: json['staff_name'],
                  receiptSeq: json['receipt_seq'],
                  receiptDateTime:
                      FormatterService().datePosParser(json['datetime']),
                  fiscalSign: json['fiscal_sign'],
                  printerSize: 80,
                  isSynced: true,
                  sendSoliq: true,
                  qrCodeURL: json['qr_code_url'],
                  sendTo1C: json['sent_to_1c'],
                  terminalId: posManagerDto.pos?.gnk_id,
                  payments: List.from(json['payments'])
                      .map((e) => PaymentsDto.fromJson(e))
                      .toList(),
                  params: ReceiptParamsDto(
                    receivedCash: (json['received_cash'] ?? 0.0).toInt(),
                    receivedCard: (json['received_card'] ?? 0.0).toInt(),
                    receivedDollar: (json['received_dollar'] ?? 0).toInt(),
                    items: (json['products'] as List<dynamic>).map((e) {
                      return EposProductDto(
                          name: e['product']['title'],
                          productId: e['product']['id'].toString(),
                          price: (e['price'] * 100).toInt(),
                          amount: (e['quantity'] * 1000).toInt(),
                          vatPercent: e['vat_percent'].toInt(),
                          vat: (e['vat'] * 100).toInt(),
                          ownerType: e['owner_type'].toInt(),
                          classCode: e['class_code'],
                          packageCode: e['package_code']);
                    }).toList(),
                  )),
            );
          } catch (e, s) {
            print(e);
            print(s);
            return null;
          }
        },
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        throw ServerException(e.response?.data.toString() ?? "Server Error",
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> createReserve(CreateReserveDto reserve) async {
    try {
      await _dioClient.postRequest(
        NetworkConstants.reserve,
        data: reserve.toJson(),
      );
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error",
            ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<List<ReserveDto>> getReserves() async {
    return await _dioClient.getRequest(
      NetworkConstants.reserve,
      converter: (response) => (response['results'] as List).map((e) {
        return ReserveDto.fromJson(e);
      }).toList(),
    );
  }

  @override
  Future<void> realizationReserve(int reserveId) async {
    try {
      await _dioClient
          .postRequest("${NetworkConstants.reserve}/$reserveId/realization");
    } catch (e) {
      if (e is DioException) {
        throw ServerException(
            e.response?.data['message'] ?? "Ошибка обработки запроса",
            e.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteReserve(int reserveId) async {
    await _dioClient.deleteRequest("${NetworkConstants.reserve}/$reserveId");
  }

  @override
  Future<void> downloadInvoice(
      int receiptId, int companyId, int contractId) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/invoice_$receiptId.xls";
      await _dioClient.downloadRequest(
          "${NetworkConstants.posReceipt}/$receiptId/invoices/download-excel?company_id=$companyId&contract_id=$contractId",
          savePath);
    } catch (_) {}
  }

  @override
  Future<ZReportInfoDto> getReportInfo() async {
    try {
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final response = await _dioClient.getRequest(
          NetworkConstants.posReportInfo,
          queryParameters: {"date": date});

      return ZReportInfoDto(
          number: 1,
          count: 1,
          totalSaleCount: response['total_sale_count'],
          totalRefundCount: response['total_refund_count'],
          totalRefundVAT: response['total_sale_count'],
          totalRefundCash: response['total_refund_cash'],
          totalRefundCard: response['total_refund_card'],
          totalSaleCard: response['total_sale_card'],
          totalSaleCash: response['total_sale_cash'].toInt(),
          totalSaleVAT: response['total_sale_vat'],
          closeTime: "",
          terminalID: "",
          openTime: "",
          appletVersion: '0000');
    } catch (e, s) {
      print(e);
      print(s);
      rethrow;
    }
  }

  @override
  Future<void> updateReserve(CreateReserveDto reserve) async {
    try {
      await _dioClient.putRequest(
        "${NetworkConstants.reserve}/${reserve.id}",
        data: reserve.toJson(),
      );
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error",
            ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }

  @override
  Future<CalculateKVIDiscountResponse> getDiscount(
      CalculateKVIDiscountRequest data) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.kvi,
        data: data.map((e) => e.toJson()).toList(),
        converter: (response) =>
            CalculateKVIDiscountResponse.fromJson(response),
      );

      return res;
    } catch (ex) {
      if (ex is DioException) {
        throw ServerException(ex.response?.data.toString() ?? "Server Error",
            ex.response?.statusCode ?? 500);
      }
      rethrow;
    }
  }
}
