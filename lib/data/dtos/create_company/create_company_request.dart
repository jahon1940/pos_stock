import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_company_request.freezed.dart';
part 'create_company_request.g.dart';

@Freezed(fromJson: true, toJson: true)
class CreateCompanyRequest with _$CreateCompanyRequest {
  factory CreateCompanyRequest({
    String? phoneNumber,
    String? birthDay,
    String? name,
    String? inn,
    String? companyType,
  }) = _CreateCompanyRequest;
}