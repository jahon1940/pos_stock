import 'dart:io' show File;

import 'package:equatable/equatable.dart';

class CreateProductDataDto extends Equatable {
  const CreateProductDataDto({
    this.nameRu = '',
    this.nameUz = '',
    this.barcodes = const [],
    this.vendorCode = '',
    this.productId = '',
    this.stockId = '',
    this.categoryName = '',
    this.categoryCid,
    this.brandName = '',
    this.brandCid,
    this.countryName = '',
    this.countryCid,
    this.quantity = 0,
    this.minBoxQuantity,
    this.maxQuantity,
    this.purchasePrice,
    this.price,
    this.imageFiles = const [],
    this.isActual = false,
    this.isBestseller = false,
    this.hasDiscount = false,
    this.promotion = false,
    this.stopList = false,
  });

  final String nameRu;
  final String nameUz;
  final List<String> barcodes;
  final String vendorCode;
  final String productId;
  final String stockId;
  final String categoryName;
  final String? categoryCid;
  final String brandName;
  final String? brandCid;
  final String countryName;
  final String? countryCid;
  final int quantity;
  final int? minBoxQuantity;
  final int? maxQuantity;
  final int? purchasePrice;
  final int? price;
  final List<File> imageFiles;
  final bool isActual;
  final bool isBestseller;
  final bool hasDiscount;
  final bool promotion;
  final bool stopList;

  CreateProductDataDto copyWith({
    String? nameRu,
    String? nameUz,
    List<String>? barcodes,
    String? vendorCode,
    String? productId,
    String? stockId,
    String? categoryName,
    String? categoryCid,
    String? brandName,
    String? brandCid,
    String? countryName,
    String? countryCid,
    int? quantity,
    int? minBoxQuantity,
    int? maxQuantity,
    int? purchasePrice,
    int? price,
    List<File>? imageFiles,
    bool? isActual,
    bool? isBestseller,
    bool? hasDiscount,
    bool? promotion,
    bool? stopList,
  }) =>
      CreateProductDataDto(
        nameRu: nameRu ?? this.nameRu,
        nameUz: nameUz ?? this.nameUz,
        barcodes: barcodes ?? this.barcodes,
        vendorCode: vendorCode ?? this.vendorCode,
        productId: productId ?? this.productId,
        stockId: stockId ?? this.stockId,
        categoryName: categoryName ?? this.categoryName,
        categoryCid: categoryCid ?? this.categoryCid,
        brandName: brandName ?? this.brandName,
        brandCid: brandCid ?? this.brandCid,
        countryName: countryName ?? this.countryName,
        countryCid: countryCid ?? this.countryCid,
        quantity: quantity ?? this.quantity,
        minBoxQuantity: minBoxQuantity ?? this.minBoxQuantity,
        maxQuantity: maxQuantity ?? this.maxQuantity,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        price: price ?? this.price,
        imageFiles: imageFiles ?? this.imageFiles,
        isActual: isActual ?? this.isActual,
        isBestseller: isBestseller ?? this.isBestseller,
        hasDiscount: hasDiscount ?? this.hasDiscount,
        promotion: promotion ?? this.promotion,
        stopList: stopList ?? this.stopList,
      );

  @override
  List<Object?> get props => [
        nameRu,
        nameUz,
        barcodes,
        vendorCode,
        productId,
        stockId,
        categoryName,
        categoryCid,
        brandName,
        brandCid,
        countryName,
        countryCid,
        quantity,
        minBoxQuantity,
        maxQuantity,
        purchasePrice,
        price,
        imageFiles,
        isActual,
        isBestseller,
        hasDiscount,
        promotion,
        stopList,
      ];

// Map<String, dynamic> toJson() => {
//       if (productId.isNotEmpty) 'product_id': productId,
//       if (name.isNotEmpty) 'title': name,
//       if (vendorCode.isNotEmpty) 'vendor_code': vendorCode,
//       if (barcodes.isNotEmpty) 'barcode': barcodes,
//       if (stockId.isNotEmpty) 'stock_id': stockId,
//       if (categoryName.isNotEmpty) 'category_name': categoryName,
//       if (categoryId.isNotNull) 'category_id': categoryId,
//       if (brandName.isNotEmpty) 'brand_name': brandName,
//       if (brandId.isNotNull) 'brand_id': brandId,
//       if (countryName.isNotEmpty) 'country_name': countryName,
//       if (countryId.isNotNull) 'country_id': countryId,
//       if (brandId.isNotNull) 'brand_id': brandId,
//       'quantity': quantity,
//       'purchase_price': purchasePrice,
//       'price': price,
//     };
}
