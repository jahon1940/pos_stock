import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/reserve_dto.dart';

import 'cart_price_dto.dart';
import 'cart_product_dto.dart';
import 'company_dto.dart';
import 'contract_dto.dart';

part 'cart_dto.freezed.dart';

@freezed
class CartDto with _$CartDto {
  factory CartDto({
    PaginatedDto<CartProductDto>? products,
    CartPriceDto? cartPrice,
    CompanyDto? client,
    ContractDto? contract,
    ReceiptDto? refundReceipt,
    ReserveDto? reserve,
    String? comment,
    @Default(false) bool fromSite,
    @Default(false) bool fromReturn,
    String? orderId,
    int? reserveId,
  }) = _CartDto;

  factory CartDto.fromJson(Map<String, dynamic> json) {
    return CartDto(
      products: json['products'] != null
          ? PaginatedDto.fromJson(
        json['products'],
            (item) => CartProductDto.fromJson(item),
      )
          : null,
      cartPrice: json['cartPrice'] != null
          ? CartPriceDto.fromJson(json['cartPrice'])
          : null,
      client: json['client'] != null
          ? CompanyDto.fromJson(json['client'])
          : null,
    );
  }
}
