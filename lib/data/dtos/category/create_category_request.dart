import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_request.freezed.dart';
part 'create_category_request.g.dart';

@freezed
class CreateCategoryRequest with _$CreateCategoryRequest {
  factory CreateCategoryRequest({
    @JsonKey(includeIfNull: false) String? cid,
    String? name,
    String? image,
    String? parentCid,
    bool? active,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);
}
