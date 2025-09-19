import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_bonus_dto.freezed.dart';
part 'company_bonus_dto.g.dart';

@freezed
class CompanyBonusDto with _$CompanyBonusDto {

  factory CompanyBonusDto({
    required int id,
    String? companyName,
    String? cardNumber,
    String? bonus
  }) = _CompanyBonusDto;

  factory CompanyBonusDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyBonusDtoFromJson(json);

}
