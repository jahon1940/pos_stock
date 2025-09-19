import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_cart_request.freezed.dart';
part 'update_cart_request.g.dart';

@Freezed(fromJson: false, toJson: true)
class UpdateCartRequest with _$UpdateCartRequest {
  factory UpdateCartRequest({
    @JsonKey(includeToJson: false) required int productId,
    required int quantity,
  }) = _UpdateCartRequest;
}
