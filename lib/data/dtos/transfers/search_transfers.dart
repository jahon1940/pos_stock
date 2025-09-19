import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_transfers.freezed.dart';
part 'search_transfers.g.dart';

@Freezed(toJson: true, fromJson: false)
class SearchTransfers with _$SearchTransfers {
  factory SearchTransfers({
    int? stockId,
    int? fromStockId,
    int? toStockId,
    String? fromDate,
    String? toDate,
    @JsonKey(defaultValue: 1, includeToJson: false) int? page,
  }) = _SearchTransfers;
}
