import 'package:freezed_annotation/freezed_annotation.dart';


part 'payment_type_dto.freezed.dart';
part 'payment_type_dto.g.dart';

@freezed
class PaymentTypeDto with _$PaymentTypeDto {
  factory PaymentTypeDto({
    required int id,
    required String name,
    required String? imageUrl,
    int? price
  }) = _PaymentTypeDto;

  factory PaymentTypeDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeDtoFromJson(json);
}