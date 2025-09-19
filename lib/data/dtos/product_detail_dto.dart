import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_param_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_detail_dto.dart';

part 'product_detail_dto.freezed.dart';
part 'product_detail_dto.g.dart';

@freezed
class ProductDetailDto with _$ProductDetailDto {
  const ProductDetailDto._();

  factory ProductDetailDto(
      {required int id,
      ProductParamDto? category,
      ProductParamDto? brand,
      ProductParamDto? madeIn,
      String? classifierCode,
      String? classifierTitle,
      String? packagename,
      String? packagecode,
      String? title,
      String? vendorCode,
      String? nds,
      int? price,
      int? priceDollar,
      int? purchasePriceUzs,
      int? purchasePriceDollar,
      dynamic contractor,
      String? measure,
      String? description,
      bool? actual,
      bool? bestseller,
      bool? discount,
      bool? promotion,
      bool? stopList,
      int? minBoxQuantity,
      String? quantityInBox,
      int? maxQuantity,
      List<String>? barcode,
      String? arrivalDate,
      double? weight,
      String? size,
      String? imageUrl,
      bool? inFav,
      bool? inCart,
      bool? hasComment,
      int? quantity,
      int? reserveQuantity,
      List<StockDetailDto>? stocks}) = _ProductDetailDto;

  factory ProductDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailDtoFromJson(json);

  int get leftQuantity {
    int quantity = 0;

    for (StockDetailDto stock in stocks ?? []) {
      quantity += stock.quantity ?? 0;
    }

    return quantity;
  }
}
