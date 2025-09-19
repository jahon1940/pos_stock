import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_info_dto.freezed.dart';
part 'products_info_dto.g.dart';

@Freezed()
class ProductsInfoDto with _$ProductsInfoDto {
  factory ProductsInfoDto({
    int? productsCount,
    int? totalQuantity,
    int? totalPrice,
    int? totalPriceDollar,
    int? totalPurchasePrice,
    int? totalPurchasePriceDollar,
  }) = _ProductsInfoDto;

  factory ProductsInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsInfoDtoFromJson(json);
}
