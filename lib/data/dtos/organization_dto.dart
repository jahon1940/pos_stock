import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

part 'organization_dto.freezed.dart';
part 'organization_dto.g.dart';

@freezed
class OrganizationDto with _$OrganizationDto {
  factory OrganizationDto({
    required int id,
    required String name,
    required String inn,
  }) = _OrganizationDto;

  factory OrganizationDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDtoFromJson(json);

  static OrganizationDto fromTable(Organizations table) {
    return OrganizationDto(
      id: table.id,
      name: table.name,
      inn: '',
    );
  }
}
