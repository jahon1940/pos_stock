import 'package:freezed_annotation/freezed_annotation.dart';

import '../product_dto.dart';

part 'supplies_1c_products.freezed.dart';
part 'supplies_1c_products.g.dart';

@freezed
class Supplies1CProducts with _$Supplies1CProducts {
  factory Supplies1CProducts({
    int? id,
    ProductDto? product,
    int? purchasePrice,
    int? price,
    int? quantity,
  }) = _Supplies1CProducts;

  factory Supplies1CProducts.fromJson(Map<String, dynamic> json) =>
      _$Supplies1CProductsFromJson(json);
}
