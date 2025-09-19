import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract_payment_dto.freezed.dart';
part 'contract_payment_dto.g.dart';

@Freezed(toJson: false)
class ContractPaymentDto with _$ContractPaymentDto {
  factory ContractPaymentDto({
    required int id,
    String? number,
    String? date,
    String? amount
  }) = _ContractPaymentDto;

  factory ContractPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$ContractPaymentDtoFromJson(json);
}
