import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/epos_product_dto.dart';
import 'package:hoomo_pos/data/dtos/payment_type_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_extra_info_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_params_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_refund_info_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

part 'receipt_dto.freezed.dart';

part 'receipt_dto.g.dart';

@freezed
class ReceiptDto with _$ReceiptDto {
  const ReceiptDto._();

  factory ReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiptDtoFromJson(json);

  factory ReceiptDto(
      {@JsonKey(includeIfNull: false, includeToJson: false) String? id,
      @JsonKey(name: "companyName") required String companyName,
      @JsonKey(name: "companyAddress") required String companyAddress,
      @JsonKey(name: "companyINN") required String companyINN,
      @JsonKey(name: "receiptType") required String receiptType,
      @JsonKey(
        name: "sale_manager_id",
        includeIfNull: false,
      )
      int? saleManagerId,
      @JsonKey(name: "staffName") required String staffName,
      @JsonKey(name: "printerSize") required int printerSize,
      @JsonKey(name: "phoneNumber", includeIfNull: false) String? phoneNumber,
      @JsonKey(name: "companyPhoneNumber", includeIfNull: false)
      String? companyPhoneNumber,
      @JsonKey(name: "terminalId", includeIfNull: false) String? terminalId,
      @JsonKey(name: "receiptSeq", includeIfNull: false) String? receiptSeq,
      @JsonKey(name: "fiscalSign", includeIfNull: false) String? fiscalSign,
      @JsonKey(name: "qrCodeURL", includeIfNull: false) String? qrCodeURL,
      @JsonKey(name: "qr_code_url", includeToJson: false) String? qrCodeUrl,
      @JsonKey(name: "dateTime", includeIfNull: false) String? receiptDateTime,
      @JsonKey(name: "closeTime", includeIfNull: false) String? closeTime,
      @JsonKey(name: "payType", includeIfNull: false) int? payType,
      @JsonKey(name: "qrToken", includeIfNull: false) String? qrToken,
      @JsonKey(includeToJson: false) required bool isSynced,
      @JsonKey(includeToJson: false) required bool sendSoliq,
      @JsonKey(name: "sent_to_1c", includeToJson: false) required bool sendTo1C,
      @JsonKey(includeToJson: false) String? cardNumber,
      @JsonKey(includeToJson: false) String? orderId,
      @JsonKey(includeToJson: false, name: "error_1c") String? error1C,
      @JsonKey(includeToJson: false) List<PaymentTypeDto>? paymentTypes,
      @JsonKey(name: "payments", includeToJson: false)
      List<PaymentsDto>? payments,
      String? paycheck,
      required ReceiptParamsDto params,
      @JsonKey(name: "extraInfo", includeIfNull: false)
      ReceiptExtraInfoDto? extraInfo,
      @JsonKey(name: "refundInfo", includeIfNull: false)
      ReceiptRefundInfoDto? refundInfo}) = _ReceiptDto;

  Receipts toReceipt() => Receipts(
        id: int.parse(id ?? receiptSeq ?? "0"),
        companyName: companyName,
        companyAddress: companyAddress,
        companyINN: companyINN,
        receiptType: receiptType,
        saleManagerId: saleManagerId,
        staffName: staffName,
        printerSize: printerSize.toString(),
        phoneNumber: phoneNumber,
        companyPhoneNumber: companyPhoneNumber,
        terminalId: terminalId,
        receiptSeq: receiptSeq,
        fiscalSign: fiscalSign,
        qrCodeURL: qrCodeURL,
        receiptDateTime: receiptDateTime,
        // Уже переименованное поле
        paycheck: paycheck,
        receivedCash: params.receivedCash,
        receivedCard: params.receivedCard,
        receivedDollar: params.receivedDollar,
        isSynced: isSynced,
        sendSoliq: sendSoliq,
        note: params.note,
        paymentTypes: jsonEncode(paymentTypes).toString(),
        itemsJson: jsonEncode(params.items
            .map((e) => e.toJson())
            .toList()), // Конвертируем список товаров в JSON
      );

  static ReceiptDto toDto(Receipts receiptDb) => ReceiptDto(
      companyName: receiptDb.companyName ?? "",
      companyAddress: receiptDb.companyAddress ?? "",
      companyINN: receiptDb.companyINN ?? "",
      receiptType: receiptDb.receiptType,
      saleManagerId: receiptDb.saleManagerId,
      staffName: receiptDb.staffName ?? "",
      printerSize: int.parse(receiptDb.printerSize ?? "58"),
      phoneNumber: receiptDb.phoneNumber,
      companyPhoneNumber: receiptDb.companyPhoneNumber,
      terminalId: receiptDb.terminalId,
      receiptSeq: receiptDb.receiptSeq,
      fiscalSign: receiptDb.fiscalSign,
      qrCodeURL: receiptDb.qrCodeURL,
      receiptDateTime: receiptDb.receiptDateTime,
      paycheck: receiptDb.paycheck,
      isSynced: receiptDb.isSynced,
      sendSoliq: receiptDb.sendSoliq,
      sendTo1C: false,
      id: receiptDb.id.toString(),
      paymentTypes:
          receiptDb.paymentTypes != null && receiptDb.paymentTypes != "null"
              ? (() {
                  final decoded = jsonDecode(receiptDb.paymentTypes!);
                  if (decoded is List) {
                    return decoded
                        .map((e) =>
                            PaymentTypeDto.fromJson(e as Map<String, dynamic>))
                        .toList();
                  }
                  return null;
                })()
              : null,
      params: ReceiptParamsDto(
          receivedCash: receiptDb.receivedCash,
          receivedCard: receiptDb.receivedCard,
          receivedDollar: receiptDb.receivedDollar,
          note: receiptDb.note,
          items: (jsonDecode(receiptDb.itemsJson) as List<dynamic>)
              .map((e) => EposProductDto.fromJson(e))
              .toList()));
}
