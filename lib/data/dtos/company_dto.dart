import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

import 'discount_card_dto.dart';

part 'company_dto.freezed.dart';
part 'company_dto.g.dart';

@freezed
class CompanyDto with _$CompanyDto {
  const CompanyDto._();

  factory CompanyDto({
    required int id,
    String? name,
    String? fullName,
    String? inn,
    String? cardNumber,
    String? companyType,
    String? region,
    String? username,
    List<String>? phoneNumbers,
    List<DiscountCardDto>? card_numbers,
    bool? isRegistered,
    bool? isActive,
  }) = _CompanyDto;

  factory CompanyDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyDtoFromJson(json);

  static CompanyDto toDto(Companies company) => CompanyDto(
    id: company.id,
    name: company.name,
    fullName: company.full_name,
    inn: company.inn,
    cardNumber: company.card_number,
    companyType: company.company_type,
    region: company.region,
    username: company.username,
    //phoneNumbers: company.phoneNumbers,
    isRegistered: company.is_registered,
    isActive: company.is_active,
  );

  Companies toCompany() => Companies(
    id: id,
    name: name,
    full_name: fullName,
    inn: inn,
    card_number: cardNumber,
    company_type: companyType,
    region: region,
    username: username,
    //phoneNumbers: phoneNumbers,
    is_registered: isRegistered,
    is_active: isActive,
  );
}
