import 'package:equatable/equatable.dart';

class CreateProductDataDto extends Equatable {
  const CreateProductDataDto({
    this.name = '',
    this.vendorCode = '',
    this.productId = '',
    this.stockId = '',
    this.categoryId,
    this.quantity = 0,
    this.purchasePrice = 0,
    this.price = 0,
  });

  final String name;
  final String vendorCode;
  final String productId;
  final String stockId;
  final int? categoryId;
  final int quantity;
  final double purchasePrice;
  final double price;

  CreateProductDataDto copyWith({
    String? name,
    String? vendorCode,
    String? productId,
    String? stockId,
    int? categoryId,
    int? quantity,
    double? purchasePrice,
    double? price,
  }) =>
      CreateProductDataDto(
        name: name ?? this.name,
        vendorCode: vendorCode ?? this.vendorCode,
        productId: productId ?? this.productId,
        stockId: stockId ?? this.stockId,
        categoryId: categoryId ?? this.categoryId,
        quantity: quantity ?? this.quantity,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        price: price ?? this.price,
      );

  @override
  List<Object?> get props => [
        name,
        vendorCode,
        productId,
        stockId,
        categoryId,
        quantity,
        purchasePrice,
        price,
      ];
}
