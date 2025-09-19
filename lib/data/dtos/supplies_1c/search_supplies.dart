import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_supplies.freezed.dart';
part 'search_supplies.g.dart';

@Freezed(toJson: true, fromJson: false)
class SearchSupplies1C with _$SearchSupplies1C {
  factory SearchSupplies1C({
    String? search,
    @JsonKey(defaultValue: 1, includeToJson: false) int? page,
  }) = _SearchSupplies1C;
}
