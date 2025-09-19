import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_request.dart';

part 'create_supply_request.freezed.dart';
part 'create_supply_request.g.dart';

@freezed
class CreateSupplyRequest with _$CreateSupplyRequest {
  factory CreateSupplyRequest({
    int? supplierId,
    required int stockId,
    required List<SupplyProductRequest> products,
  }) = _CreateSupplyRequest;

  factory CreateSupplyRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSupplyRequestFromJson(json);
}
