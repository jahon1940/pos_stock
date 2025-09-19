import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_product_request.freezed.dart';
part 'inventory_product_request.g.dart';

@freezed
class InventoryProductRequest with _$InventoryProductRequest {
  factory InventoryProductRequest({
    @JsonKey(includeToJson: false) String? title,
    required int productId,
    required int realQuantity,
    @JsonKey(includeToJson: false) int? oldQuantity,
    @JsonKey(includeToJson: false) int? quantityDiff,
    @JsonKey(includeToJson: false) String? price,
    @JsonKey(includeToJson: false) int? priceDiff,
  }) = _InventoryProductRequest;

  factory InventoryProductRequest.fromJson(Map<String, dynamic> json) =>
      _$InventoryProductRequestFromJson(json);
}
