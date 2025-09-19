import 'package:freezed_annotation/freezed_annotation.dart';

part 'supply_product_request.freezed.dart';
part 'supply_product_request.g.dart';

@freezed
class SupplyProductRequest with _$SupplyProductRequest {
  factory SupplyProductRequest({
    @JsonKey(includeToJson: false) String? title,
    required int productId,
    required int quantity,
    String? purchasePrice,
    String? price,
  }) = _SupplyProductRequest;

  factory SupplyProductRequest.fromJson(Map<String, dynamic> json) =>
      _$SupplyProductRequestFromJson(json);
}
