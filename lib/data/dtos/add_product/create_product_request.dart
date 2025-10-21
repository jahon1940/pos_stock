// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_product_request.freezed.dart';
part 'create_product_request.g.dart';

@Freezed(fromJson: true, toJson: true)
class CreateProductRequest with _$CreateProductRequest {
  factory CreateProductRequest({
    @JsonKey(includeIfNull: false) String? cid,
    @JsonKey(includeIfNull: false) int? productId,
    @JsonKey(includeIfNull: false) String? title,
    @JsonKey(includeIfNull: false) String? vendorCode,
    @JsonKey(includeIfNull: false) List<String>? barcode,
    @JsonKey(includeIfNull: false) int? stockId,
    @JsonKey(includeIfNull: false) String? categoryCid,
    @JsonKey(includeIfNull: false) String? brandCid,
    @JsonKey(includeIfNull: false) String? madeInCid,
    @JsonKey(includeIfNull: false) int? quantity,
    @JsonKey(includeIfNull: false) String? purchasePrice,
    @JsonKey(includeIfNull: false) String? price,
    @JsonKey(includeIfNull: false) String? image,
    @JsonKey(includeIfNull: false) List<String>? images,
  }) = _CreateProductRequest;
}
