import 'package:equatable/equatable.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';

class CreateProductDataDto extends Equatable {
  const CreateProductDataDto({
    this.name = '',
    this.barcode = '',
    this.vendorCode = '',
    this.productId = '',
    this.stockId = '',
    this.categoryName = '',
    this.categoryId,
    this.quantity = 0,
    this.purchasePrice,
    this.price,
  });

  final String name;
  final String barcode;
  final String vendorCode;
  final String productId;
  final String stockId;
  final String categoryName;
  final int? categoryId;
  final int quantity;
  final int? purchasePrice;
  final int? price;

  CreateProductDataDto copyWith({
    String? name,
    String? barcode,
    String? vendorCode,
    String? productId,
    String? stockId,
    String? categoryName,
    int? categoryId,
    int? quantity,
    int? purchasePrice,
    int? price,
  }) =>
      CreateProductDataDto(
        name: name ?? this.name,
        barcode: barcode ?? this.barcode,
        vendorCode: vendorCode ?? this.vendorCode,
        productId: productId ?? this.productId,
        stockId: stockId ?? this.stockId,
        categoryName: categoryName ?? this.categoryName,
        categoryId: categoryId ?? this.categoryId,
        quantity: quantity ?? this.quantity,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        price: price ?? this.price,
      );

  @override
  List<Object?> get props => [
        name,
        barcode,
        vendorCode,
        productId,
        stockId,
        categoryName,
        categoryId,
        quantity,
        purchasePrice,
        price,
      ];

  Map<String, dynamic> toJson() => {
        if (productId.isNotEmpty) 'product_id': productId,
        if (name.isNotEmpty) 'title': name,
        if (vendorCode.isNotEmpty) 'vendor_code': vendorCode,
        if (barcode.isNotEmpty) 'barcode': barcode,
        if (stockId.isNotEmpty) 'stock_id': stockId,
        if (categoryId.isNotNull) 'category_name': categoryName,
        if (categoryId.isNotNull) 'category_id': categoryId,
        'quantity': quantity,
        'purchase_price': purchasePrice,
        'price': price,
      };
}
