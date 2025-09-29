import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/order_product_dto.dart';

import 'discount_card_dto.dart';

part 'order_dto.freezed.dart';
part 'order_dto.g.dart';

@Freezed(toJson: false)
class OrderDto with _$OrderDto {
  factory OrderDto({
    required int id,
    required String orderNumber,
    required int price,
    int? stock,
    int? region,
    String? status,
    String? comment,
    String? createdDate,
    String? paymentType,
    String? paymentStatus,
    String? deliverType,
    @JsonKey(name: "head_company") CompanyDto? company,
    List<DiscountCardDto>? cardNumbers,
    required List<OrderProductDto> products
  }) = _OrderDto;

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);
}
