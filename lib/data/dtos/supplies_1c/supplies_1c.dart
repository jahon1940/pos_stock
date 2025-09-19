import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';

import '../stock_dto.dart';

part 'supplies_1c.freezed.dart';
part 'supplies_1c.g.dart';

@freezed
class Supplies1C with _$Supplies1C {
  factory Supplies1C({
    int? id,
    String? cid,
    SupplierDto? supplier,
    StockDto? stock,
    String? date,
    String? number,
    String? supplyType,
    bool? conducted,
    bool? isDeleted,
  }) = _Supplies1C;

  factory Supplies1C.fromJson(Map<String, dynamic> json) =>
      _$Supplies1CFromJson(json);
}
