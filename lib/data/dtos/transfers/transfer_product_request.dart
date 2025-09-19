import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_product_request.freezed.dart';
part 'transfer_product_request.g.dart';

@freezed
class TransferProductRequest with _$TransferProductRequest {
  factory TransferProductRequest({
    @JsonKey(includeToJson: false) String? title,
    required int productId,
    required int quantity,
  }) = _TransferProductRequest;

  factory TransferProductRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferProductRequestFromJson(json);
}
