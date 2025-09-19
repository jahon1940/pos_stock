import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract_dto.freezed.dart';
part 'contract_dto.g.dart';

@Freezed()
class ContractDto with _$ContractDto {
  factory ContractDto({
    required int id,
    String? name,
    String? number,
    String? date,
  }) = _ContractDto;

  factory ContractDto.fromJson(Map<String, dynamic> json) =>
      _$ContractDtoFromJson(json);
}