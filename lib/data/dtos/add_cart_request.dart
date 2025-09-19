import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_cart_request.freezed.dart';
part 'add_cart_request.g.dart';

@Freezed(fromJson: false, toJson: true)
class AddCartRequest with _$AddCartRequest {
  factory AddCartRequest({
    required int productId,
    required int quantity,
  }) = _AddCartRequest;
}
