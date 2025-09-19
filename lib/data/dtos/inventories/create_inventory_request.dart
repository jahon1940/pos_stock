import 'package:freezed_annotation/freezed_annotation.dart';

import 'inventory_product_request.dart';

part 'create_inventory_request.freezed.dart';
part 'create_inventory_request.g.dart';

@freezed
class CreateInventoryRequest with _$CreateInventoryRequest {
  factory CreateInventoryRequest({
    int? supplierId,
    required int stockId,
    required List<InventoryProductRequest> products,
  }) = _CreateInventoryRequest;

  factory CreateInventoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInventoryRequestFromJson(json);
}
