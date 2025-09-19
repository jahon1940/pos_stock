import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_supplies.freezed.dart';
part 'search_supplies.g.dart';

@Freezed(toJson: true, fromJson: false)
class SearchSupplies with _$SearchSupplies {
  factory SearchSupplies({
    int? supplierId,
    int? stockId,
    String? fromDate,
    String? toDate,
    @JsonKey(defaultValue: 1, includeToJson: false) int? page,
  }) = _SearchSupplies;
}
