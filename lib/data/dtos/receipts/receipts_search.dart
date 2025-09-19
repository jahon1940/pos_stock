import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipts_search.freezed.dart';
part 'receipts_search.g.dart';

@freezed
class SearchReceipts with _$SearchReceipts {
  factory SearchReceipts({
    String? receiptNumber,
    String? fromDate,
    String? toDate,
    int? paymentTypeId,
    @Default(1) int page,
  }) = _SearchReceipts;

  factory SearchReceipts.fromJson(Map<String, dynamic> json) =>
      _$SearchReceiptsFromJson(json);
}
