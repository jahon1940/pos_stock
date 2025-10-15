// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_brand_request.freezed.dart';

part 'update_brand_request.g.dart';

@freezed
class UpdateBrandRequest with _$UpdateBrandRequest {
  factory UpdateBrandRequest({
    @JsonKey(includeIfNull: false) String? name,
    @JsonKey(includeIfNull: false) String? image,
    @JsonKey(includeIfNull: false) bool? isDeleted,
  }) = _UpdateBrandRequest;

  factory UpdateBrandRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateBrandRequestFromJson(json);
}
