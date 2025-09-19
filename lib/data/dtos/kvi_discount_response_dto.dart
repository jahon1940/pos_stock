import 'package:freezed_annotation/freezed_annotation.dart';

part 'kvi_discount_response_dto.freezed.dart';
part 'kvi_discount_response_dto.g.dart';

@freezed
class CalculateKVIDiscountResponse with _$CalculateKVIDiscountResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CalculateKVIDiscountResponse({
    // Total price
    required double totalPrice,

    // Список элементов
    required List<CalculateKVIDiscountResponseItem> items,
  }) = _CalculateKVIDiscountResponse;

  factory CalculateKVIDiscountResponse.fromJson(Map<String, dynamic> json) =>
      _$CalculateKVIDiscountResponseFromJson(json);
}

@freezed
class CalculateKVIDiscountResponseItem with _$CalculateKVIDiscountResponseItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CalculateKVIDiscountResponseItem({
    // Product id
    required int productId,

    // Original price
    required double originalPrice,

    // Price
    required double price,

    // Is discounted
    required bool isDiscounted,

    // Discount amount
    required double discountAmount,
    int? quantity,
    double? totalItemPrice,
  }) = _CalculateKVIDiscountResponseItem;

  factory CalculateKVIDiscountResponseItem.fromJson(
          Map<String, dynamic> json) =>
      _$CalculateKVIDiscountResponseItemFromJson(json);
}
