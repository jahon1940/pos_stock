import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_dto.freezed.dart';
part 'supplier_dto.g.dart';

@freezed
class SupplierDto with _$SupplierDto {
  factory SupplierDto({
    required int id,
    String? name,
    String? inn,
    String? phoneNumber,
  }) = _SupplierDto;

  factory SupplierDto.fromJson(Map<String, dynamic> json) =>
      _$SupplierDtoFromJson(json);
}
