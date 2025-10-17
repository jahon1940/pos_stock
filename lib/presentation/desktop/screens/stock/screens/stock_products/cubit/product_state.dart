part of 'product_cubit.dart';

class ProductState extends Equatable {
  final bool isUpdated;

  const ProductState({
    this.isUpdated = false,
    this.product,
    this.status = StateStatus.loading,
    this.categoryId,
    this.createProductStatus = StateStatus.loading,
  });

  final ProductDetailDto? product;
  final StateStatus status;
  final int? categoryId;
  final StateStatus createProductStatus;

  ProductState copyWith({
    ProductDetailDto? product,
    StateStatus? status,
    int? categoryId,
    StateStatus? createProductStatus,
  }) =>
      ProductState(
        isUpdated: !isUpdated,
        product: product ?? this.product,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
        createProductStatus: createProductStatus ?? this.createProductStatus,
      );

  @override
  List<Object?> get props => [
        isUpdated,
        product,
        status,
        categoryId,
        createProductStatus,
      ];
}
