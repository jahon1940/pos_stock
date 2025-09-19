import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_write_off.freezed.dart';
part 'search_write_off.g.dart';

@Freezed(toJson: true, fromJson: false)
class SearchWriteOff with _$SearchWriteOff {
  factory SearchWriteOff({
    int? stockId,
    int? fromStockId,
    String? fromDate,
    String? toDate,
    @JsonKey(defaultValue: 1, includeToJson: false) int? page,
  }) = _SearchWriteOff;
}
