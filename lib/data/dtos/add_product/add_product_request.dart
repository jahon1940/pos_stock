import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_product_request.freezed.dart';
part 'add_product_request.g.dart';

@Freezed(fromJson: true, toJson: true)
class CreateProductRequest with _$CreateProductRequest {
  factory CreateProductRequest({
    @JsonKey(includeIfNull: false) String? cid,
    @JsonKey(includeIfNull: false) int? productId,
    @JsonKey(includeIfNull: false) String? title,
    @JsonKey(includeIfNull: false) String? vendorCode,
    @JsonKey(includeIfNull: false) List<String>? barcode,
    @JsonKey(includeIfNull: false) int? stockId,
    @JsonKey(includeIfNull: false) int? categoryId,
    int? quantity,
    String? purchasePrice,
    String? price,
  }) = _CreateProductRequest;
}
