part of 'product_cubit.dart';

class ProductState extends Equatable {
  final bool isUpdated;

  const ProductState({
    this.isUpdated = false,
    this.productPageData = const PaginatedDto(
      results: [],
      pageNumber: 1,
      pageSize: 1,
      totalPages: 1,
      count: 1,
    ),
    this.status = StateStatus.loading,
    this.categoryId,
    this.createProductStatus = StateStatus.loading,
  });

  final PaginatedDto<ProductDto> productPageData;
  final StateStatus status;
  final int? categoryId;
  final StateStatus createProductStatus;

  ProductState copyWith({
    PaginatedDto<ProductDto>? productPageData,
    StateStatus? status,
    int? categoryId,
    StateStatus? createProductStatus,
  }) =>
      ProductState(
        isUpdated: !isUpdated,
        productPageData: productPageData ?? this.productPageData,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
        createProductStatus: createProductStatus ?? this.createProductStatus,
      );

  @override
  List<Object?> get props => [
        isUpdated,
        productPageData,
        status,
        categoryId,
        createProductStatus,
      ];
}
