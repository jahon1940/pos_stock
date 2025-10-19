import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_param_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_detail_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';

import 'organization_dto.dart';

part 'product_detail_dto.freezed.dart';
part 'product_detail_dto.g.dart';

@freezed
class ProductDetailDto with _$ProductDetailDto {
  const ProductDetailDto._();

  factory ProductDetailDto(
      {
        required int id,
        required String cid,
        required ProductParamDto organization,
        required ProductParamDto category,
        required ProductParamDto brand,
        @JsonKey(name: 'made_in') required ProductParamDto madeIn,
        @JsonKey(name: 'classifier_code') String? classifierCode,
        @JsonKey(name: 'classifier_title') String? classifierTitle,
        String? packagename,
        String? packagecode,
        required String title,
        @JsonKey(name: 'title_slug') String? titleSlug,
        @JsonKey(name: 'vendor_code') String? vendorCode,
        String? nds,
        int? price,
        @JsonKey(name: 'price_discount') int? priceDiscount,
        @JsonKey(name: 'retailer_price') int? retailerPrice,
        String? measure,
        String? description,
        bool? actual,
        bool? bestseller,
        bool? discount,
        bool? promotion,
        @JsonKey(name: 'stop_list') bool? stopList,
        @JsonKey(name: 'min_box_quantity') int? minBoxQuantity,
        @JsonKey(name: 'quantity_in_box') String? quantityInBox,
        @JsonKey(name: 'max_quantity') int? maxQuantity,
        dynamic preOrder,
        List<String>? barcode,
        @JsonKey(name: 'arrival_date') String? arrivalDate,
        double? weight,
        String? size,
        @JsonKey(name: 'image_url') String? imageUrl,
        @JsonKey(name: 'in_fav') bool? inFav,
        @JsonKey(name: 'in_cart') bool? inCart,
        @JsonKey(name: 'has_comment') bool? hasComment,
        List<StockDetailDto>? stocks,
        dynamic contractor,

      int? priceDollar,
      int? purchasePriceUzs,
      int? purchasePriceDollar,

      int? quantity,
      int? reserveQuantity,



      }) = _ProductDetailDto;

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
