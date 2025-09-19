import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplies_1c_conduct.freezed.dart';
part 'supplies_1c_conduct.g.dart';

@freezed
class SuppliesConduct with _$SuppliesConduct {
  factory SuppliesConduct({
    String? cid,
    String? supplyType,
  }) = _SuppliesConduct;

  factory SuppliesConduct.fromJson(Map<String, dynamic> json) =>
      _$SuppliesConductFromJson(json);
}
