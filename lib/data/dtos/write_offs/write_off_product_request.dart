import 'package:freezed_annotation/freezed_annotation.dart';

part 'write_off_product_request.freezed.dart';
part 'write_off_product_request.g.dart';

@freezed
class WriteOffProductRequest with _$WriteOffProductRequest {
  factory WriteOffProductRequest({
    @JsonKey(includeToJson: false) String? title,
    required int productId,
    String? comment,
    required int quantity,
  }) = _WriteOffProductRequest;

  factory WriteOffProductRequest.fromJson(Map<String, dynamic> json) =>
      _$WriteOffProductRequestFromJson(json);
}
