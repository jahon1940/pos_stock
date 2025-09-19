import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_inventories.freezed.dart';
part 'search_inventories.g.dart';

@Freezed(toJson: true, fromJson: false)
class SearchInventories with _$SearchInventories {
  factory SearchInventories({
    int? stockId,
    String? fromDate,
    String? toDate,
    @JsonKey(defaultValue: 1, includeToJson: false) int? page,
  }) = _SearchInventories;
}
