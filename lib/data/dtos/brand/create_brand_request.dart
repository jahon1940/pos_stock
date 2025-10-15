import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_brand_request.freezed.dart';

part 'create_brand_request.g.dart';

@freezed
class CreateBrandRequest with _$CreateBrandRequest {
  factory CreateBrandRequest({
    required String cid,
    String? organizationCid,
    String? name,
    String? image,
  }) = _CreateBrandRequest;

  factory CreateBrandRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CreateBrandRequestFromJson(json);
}
