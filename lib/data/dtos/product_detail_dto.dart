// // ignore_for_file: invalid_annotation_target
//
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:hoomo_pos/data/dtos/product_param_dto.dart';
// import 'package:hoomo_pos/data/dtos/stock_detail_dto.dart';
//
// part 'product_detail_dto.freezed.dart';
//
// part 'product_detail_dto.g.dart';
//
// @freezed
// class ProductDetailDto with _$ProductDetailDto {
//   const ProductDetailDto._();
//
//   factory ProductDetailDto({
//     required int id,
//     required String cid,
//     required ProductParamDto organization,
//     required ProductParamDto category,
//     required ProductParamDto brand,
//     @JsonKey(name: 'made_in') required ProductParamDto madeIn,
//     @JsonKey(name: 'classifier_code') String? classifierCode,
//     @JsonKey(name: 'classifier_title') String? classifierTitle,
//     String? packagename,
//     String? packagecode,
//     required String title,
//     @JsonKey(name: 'title_slug') String? titleSlug,
//     @JsonKey(name: 'vendor_code') String? vendorCode,
//     String? nds,
//     int? price,
//     @JsonKey(name: 'price_discount') int? priceDiscount,
//     String? measure,
//     String? description,
//     bool? actual,
//     bool? bestseller,
//     bool? discount,
//     bool? promotion,
//     @JsonKey(name: 'stop_list') bool? stopList,
//     @JsonKey(name: 'min_box_quantity') int? minBoxQuantity,
//     @JsonKey(name: 'quantity_in_box') String? quantityInBox,
//     @JsonKey(name: 'max_quantity') int? maxQuantity,
//     dynamic preOrder,
//     List<String>? barcode,
//     @JsonKey(name: 'arrival_date') String? arrivalDate,
//     double? weight,
//     String? size,
//     @JsonKey(name: 'image_url') String? imageUrl,
//     @JsonKey(name: 'in_fav') bool? inFav,
//     @JsonKey(name: 'in_cart') bool? inCart,
//     @JsonKey(name: 'has_comment') bool? hasComment,
//     List<StockDetailDto>? stocks,
//     dynamic contractor,
//     int? priceDollar,
//     int? purchasePriceUzs,
//     int? purchasePriceDollar,
//     int? quantity,
//     int? reserveQuantity,
//   }) = _ProductDetailDto;
//
//   factory ProductDetailDto.fromJson(Map<String, dynamic> json) => _$ProductDetailDtoFromJson(json);
//
//   int get leftQuantity {
//     int quantity = 0;
//
//     for (StockDetailDto stock in stocks ?? []) {
//       quantity += stock.quantity ?? 0;
//     }
//
//     return quantity;
//   }
// }

import 'package:hoomo_pos/data/dtos/product_param_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_detail_dto.dart';

class ProductDetailDto {
  int? _id;
  String? cid;
  ProductParamDto? _organization;
  ProductParamDto? _category;
  ProductParamDto? _brand;
  ProductParamDto? _madeIn;
  String? classifierCode;
  String? classifierTitle;
  String? packagename;
  String? packagecode;
  String? _title;
  String? _titleRu;
  String? _titleUz;
  String? titleSlug;
  String? vendorCode;
  String? nds;
  int? price;
  int? priceDiscount;
  int? retailerPrice;
  String? measure;
  String? description;
  bool? actual;
  bool? bestseller;
  bool? discount;
  bool? promotion;
  bool? stopList;
  int? minBoxQuantity;
  String? quantityInBox;
  int? maxQuantity;
  dynamic preOrder;
  List<String>? barcode;
  String? arrivalDate;
  double? weight;
  String? size;
  String? imageUrl;
  bool? inFav;
  bool? inCart;
  bool? hasComment;
  List<StockDetailDto>? _stocks;
  dynamic contractor;
  int? priceDollar;
  int? purchasePriceUzs;
  int? purchasePriceDollar;
  int? quantity;
  int? reserveQuantity;

  int get id => _id!;

  ProductParamDto? get organization => _organization;

  ProductParamDto? get category => _category;

  ProductParamDto? get brand => _brand;

  ProductParamDto? get madeIn => _madeIn;

  String? get title => _title;

  String? get titleRu => (_titleRu ?? '').isNotEmpty ? _titleRu! : title;

  String? get titleUz => (_titleUz ?? '').isNotEmpty ? _titleUz! : title;

  List<StockDetailDto> get stocks => _stocks ?? [];

  ProductDetailDto.fromJson(
    Map<String, dynamic> json,
  ) {
    _id = int.tryParse(json['id'].toString());
    cid = json['cid'] ?? '';
    if (json['organization'] != null) {
      _organization = ProductParamDto.fromJson(json['organization'] as Map<String, dynamic>);
    }
    if (json['category'] != null) {
      _category = ProductParamDto.fromJson(json['category'] as Map<String, dynamic>);
    }
    if (json['brand'] != null) {
      _brand = ProductParamDto.fromJson(json['brand'] as Map<String, dynamic>);
    }
    if (json['made_in'] != null) {
      _madeIn = ProductParamDto.fromJson(json['made_in'] as Map<String, dynamic>);
    }
    classifierCode = json['classifier_code'] as String?;
    classifierTitle = json['classifier_title'] as String?;
    packagename = json['packagename'] as String?;
    packagecode = json['packagecode'] as String?;
    _title = (json['title'] as String?);
    _titleRu = (json['title_ru'] as String?);
    _titleUz = (json['title_uz'] as String?);
    titleSlug = json['title_slug'] as String?;
    vendorCode = json['vendor_code'] as String?;
    nds = json['nds'] as String?;
    price = int.tryParse(json['price'].toString());
    priceDiscount = int.tryParse(json['price_discount'].toString());
    retailerPrice = int.tryParse(json['retailer_price'].toString());
    measure = json['measure'] as String?;
    description = json['description'] as String?;
    actual = json['actual'] as bool?;
    bestseller = bool.tryParse(json['bestseller'].toString());
    discount = bool.tryParse(json['discount'].toString());
    promotion = bool.tryParse(json['promotion'].toString());
    stopList = bool.tryParse(json['stop_list'].toString());
    minBoxQuantity = int.tryParse(json['min_box_quantity'].toString());

    quantityInBox = json['quantity_in_box'] as String?;
    maxQuantity = int.tryParse(json['max_quantity'].toString());
    preOrder = json['pre_order'];
    barcode = (json['barcode'] as List<dynamic>?)?.map((e) => e.toString()).toList();
    arrivalDate = json['arrival_date'] as String?;
    weight = double.tryParse(json['weight'].toString());
    size = json['size'] as String?;
    imageUrl = json['image_url'] as String?;
    inFav = bool.tryParse(json['in_fav'].toString());
    inCart = bool.tryParse(json['in_cart'].toString());
    hasComment = bool.tryParse(json['has_comment'].toString());
    _stocks =
        (json['stocks'] as List<dynamic>?)?.map((e) => StockDetailDto.fromJson(e as Map<String, dynamic>)).toList();
    contractor = json['contractor'];
    priceDollar = int.tryParse(json['price_dollar'].toString());
    purchasePriceUzs = int.tryParse(json['purchase_price_uzs'].toString());
    purchasePriceDollar = int.tryParse(json['purchase_price_dollar'].toString());
    quantity = int.tryParse(json['quantity'].toString());
    reserveQuantity = int.tryParse(json['reserve_quantity'].toString());
  }

  int get leftQuantity {
    int quantity = 0;
    for (StockDetailDto stock in stocks) {
      quantity += stock.quantity ?? 0;
    }
    return quantity;
  }
}
