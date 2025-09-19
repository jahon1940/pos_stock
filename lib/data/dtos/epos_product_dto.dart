import 'package:freezed_annotation/freezed_annotation.dart';

part 'epos_product_dto.freezed.dart';
part 'epos_product_dto.g.dart';

@freezed
class EposProductDto with _$EposProductDto {
  const EposProductDto._();

  factory EposProductDto({
    required String name,
    @JsonKey(name: "productId") required String? productId,
    @JsonKey(includeIfNull: false) int? discount,
    @JsonKey(includeIfNull: false) int? other,
    required int price,
    required int amount,
    @JsonKey(name: "vatPercent") required int vatPercent,
    @JsonKey(name: "vat") required int vat,
    @JsonKey(name: "ownerType") required int ownerType,
    @JsonKey(name: "classCode") required String classCode,
    @JsonKey(name: "packageCode") required String packageCode,
    @JsonKey(includeIfNull: false) String? label,
    @JsonKey(name: "commissionTIN", includeIfNull: false) String? commissionTIN,
  }) = _EposProductDto;

  factory EposProductDto.fromJson(Map<String, dynamic> json) =>
      _$EposProductDtoFromJson(json);

  Map<String, dynamic> toEposJson() => toJson().remove("productId");
}
