import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/product_in_stocks_dto.dart';
import 'package:hoomo_pos/data/dtos/product_param_dto.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

part 'product_dto.freezed.dart';

part 'product_dto.g.dart';

@freezed
class ProductDto with _$ProductDto {
  const ProductDto._();

  factory ProductDto({
    required int id,
    ProductParamDto? category,
    ProductParamDto? brand,
    ProductParamDto? madeIn,
    String? classifierCode,
    String? classifierTitle,
    String? packagename,
    String? packagecode,
    String? title,
    String? titleRu,
    String? titleUz,
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
    @Default([]) List<ProductInStocksDto> stocks,
    int? freeQuantity,
    int? quantity,
    int? reserveQuantity,
    int? saleCount,
    SupplierDto? supplier,
  }) = _ProductDto;

  int get globalQuantity {
    int quantity = 0;

    for (var s in stocks) {
      quantity += s.quantity ?? 0;
    }

    return quantity;
  }

  int get reserve {
    int quantity = 0;

    for (var s in stocks) {
      quantity += s.quantityReserve ?? 0;
    }

    return quantity;
  }

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  static ProductDto toDto(Products product,
      {Categories? category,
      (int freeQuantity, int quantity, int reserveQuantity)? quantity}) {
    return ProductDto(
        id: product.id,
        category: product.category != null && category != null
            ? ProductParamDto(
                id: category.id,
                name: category.name,
                imageUrl: category.image_url,
              )
            : null,
        brand: product.brand != null
            ? ProductParamDto(
                id: product.brand!,
                name: '',
                imageUrl: '',
              )
            : null,
        madeIn: product.made_in != null
            ? ProductParamDto(
                id: product.made_in!,
                name: '',
                imageUrl: '',
              )
            : null,
        classifierCode: product.classifier_code,
        classifierTitle: product.classifier_title,
        packagename: product.packagename,
        packagecode: product.packagecode,
        title: (product.title?.isNotEmpty ?? false)
            ? product.title
            : product.title_uz,
        titleRu: product.title_ru,
        titleUz: product.title_uz,
        vendorCode: product.vendor_code,
        nds: product.nds,
        price: product.price,
        measure: product.measure,
        description: product.description,
        actual: product.actual,
        bestseller: product.bestseller,
        discount: product.discount,
        promotion: product.promotion,
        stopList: product.stop_list,
        minBoxQuantity: product.min_box_quantity,
        quantityInBox: product.quantity_in_box,
        maxQuantity: product.max_quantity,
        barcode: List<String>.from(product.barcode ?? []),
        arrivalDate: product.arrival_date,
        weight: product.weight,
        size: product.size,
        imageUrl: product.image_url,
        inFav: product.in_fav,
        inCart: product.in_cart,
        hasComment: product.has_comment,
        stocks: [],
        freeQuantity: quantity?.$1,
        quantity: quantity?.$2,
        reserveQuantity: quantity?.$3,
        priceDollar: product.price_dollar,
        purchasePriceUzs: product.purchase_price_uzs,
        purchasePriceDollar: product.purchase_price_dollar);
  }

  Products toProduct() => Products(
      id: id,
      category: category?.id,
      brand: brand?.id,
      made_in: madeIn?.id,
      classifier_code: classifierCode,
      classifier_title: classifierTitle,
      packagename: packagename,
      packagecode: packagecode,
      title: title,
      title_ru: titleRu,
      title_uz: titleUz,
      vendor_code: vendorCode,
      nds: nds,
      price: price,
      measure: measure,
      description: description,
      actual: actual,
      bestseller: bestseller,
      discount: discount,
      promotion: promotion,
      stop_list: stopList,
      min_box_quantity: minBoxQuantity,
      quantity_in_box: quantityInBox,
      max_quantity: maxQuantity,
      barcode: barcode,
      arrival_date: arrivalDate,
      weight: weight,
      size: size,
      image_url: imageUrl,
      in_fav: inFav,
      in_cart: inCart,
      has_comment: hasComment,
      price_dollar: priceDollar,
      purchase_price_dollar: purchasePriceDollar,
      purchase_price_uzs: purchasePriceUzs);
}
