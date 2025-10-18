import 'dart:io' show File;

import 'package:equatable/equatable.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';

class CreateProductDataDto extends Equatable {
  const CreateProductDataDto({
    this.name = '',
    this.barcodes = const [],
    this.vendorCode = '',
    this.productId = '',
    this.stockId = '',
    this.categoryName = '',
    this.categoryId,
    this.brandName = '',
    this.brandId,
    this.countryName = '',
    this.countryId,
    this.quantity = 0,
    this.purchasePrice,
    this.price,
    this.imageFiles = const [],
  });

  final String name;
  final List<String> barcodes;
  final String vendorCode;
  final String productId;
  final String stockId;
  final String categoryName;
  final int? categoryId;
  final String brandName;
  final int? brandId;
  final String countryName;
  final int? countryId;
  final int quantity;
  final int? purchasePrice;
  final int? price;
  final List<File> imageFiles;

  CreateProductDataDto copyWith({
    String? name,
    List<String>? barcodes,
    String? vendorCode,
    String? productId,
    String? stockId,
    String? categoryName,
    int? categoryId,
    String? brandName,
    int? brandId,
    String? countryName,
    int? countryId,
    int? quantity,
    int? purchasePrice,
    int? price,
    List<File>? imageFiles,
  }) =>
      CreateProductDataDto(
        name: name ?? this.name,
        barcodes: barcodes ?? this.barcodes,
        vendorCode: vendorCode ?? this.vendorCode,
        productId: productId ?? this.productId,
        stockId: stockId ?? this.stockId,
        categoryName: categoryName ?? this.categoryName,
        categoryId: categoryId ?? this.categoryId,
        brandName: brandName ?? this.brandName,
        brandId: brandId ?? this.brandId,
        countryName: countryName ?? this.countryName,
        countryId: countryId ?? this.countryId,
        quantity: quantity ?? this.quantity,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        price: price ?? this.price,
        imageFiles: imageFiles ?? this.imageFiles,
      );

  @override
  List<Object?> get props => [
        name,
        barcodes,
        vendorCode,
        productId,
        stockId,
        categoryName,
        categoryId,
        brandName,
        brandId,
        countryName,
        countryId,
        quantity,
        purchasePrice,
        price,
        imageFiles,
      ];

  Map<String, dynamic> toJson() => {
        if (productId.isNotEmpty) 'product_id': productId,
        if (name.isNotEmpty) 'title': name,
        if (vendorCode.isNotEmpty) 'vendor_code': vendorCode,
        if (barcodes.isNotEmpty) 'barcode': barcodes,
        if (stockId.isNotEmpty) 'stock_id': stockId,
        if (categoryName.isNotEmpty) 'category_name': categoryName,
        if (categoryId.isNotNull) 'category_id': categoryId,
        if (brandName.isNotEmpty) 'brand_name': brandName,
        if (brandId.isNotNull) 'brand_id': brandId,
        if (countryName.isNotEmpty) 'country_name': countryName,
        if (countryId.isNotNull) 'country_id': countryId,
        if (brandId.isNotNull) 'brand_id': brandId,
        'quantity': quantity,
        'purchase_price': purchasePrice,
        'price': price,
      };
}
