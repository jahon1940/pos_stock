// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_request.freezed.dart';
part 'search_request.g.dart';

@Freezed(toJson: true, fromJson: false)
class SearchRequest with _$SearchRequest {
  factory SearchRequest({
    @JsonKey(defaultValue: '') String? title,
    int? organizationId,
    List<int>? brands,
    int? categoryId,
    int? priceFrom,
    int? priceTo,
    int? supplierId,
    int? stockId,
    @JsonKey(defaultValue: '-created_at') String? orderBy,
    @JsonKey(defaultValue: 1, includeToJson: false) int? page,
  }) = _SearchRequest;
}
