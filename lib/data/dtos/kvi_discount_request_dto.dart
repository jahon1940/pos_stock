import 'package:freezed_annotation/freezed_annotation.dart';

part 'kvi_discount_request_dto.freezed.dart';
part 'kvi_discount_request_dto.g.dart';

// Тип для всего тела запроса, так как это массив объектов
typedef CalculateKVIDiscountRequest = List<CalculateKVIDiscountItem>;

@freezed
class CalculateKVIDiscountItem with _$CalculateKVIDiscountItem {

  const factory CalculateKVIDiscountItem({
    required int productId,
    required int price,
    required int quantity,
  }) = _CalculateKVIDiscountItem;

  factory CalculateKVIDiscountItem.fromJson(Map<String, dynamic> json) =>
      _$CalculateKVIDiscountItemFromJson(json);
}
