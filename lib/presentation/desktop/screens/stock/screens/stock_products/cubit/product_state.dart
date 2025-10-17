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
    this.status = StateStatus.initial,
    this.createProductStatus = StateStatus.loading,
    this.createProductDataDto = const CreateProductDataDto(),
  });

  final PaginatedDto<ProductDto> productPageData;
  final StateStatus status;
  final StateStatus createProductStatus;
  final CreateProductDataDto createProductDataDto;

  ProductState copyWith({
    PaginatedDto<ProductDto>? productPageData,
    StateStatus? status,
    StateStatus? createProductStatus,
    CreateProductDataDto? createProductDataDto,
  }) =>
      ProductState(
        isUpdated: !isUpdated,
        productPageData: productPageData ?? this.productPageData,
        status: status ?? this.status,
        createProductStatus: createProductStatus ?? this.createProductStatus,
        createProductDataDto: createProductDataDto ?? this.createProductDataDto,
      );

  @override
  List<Object?> get props => [
        isUpdated,
        productPageData,
        status,
        createProductStatus,
        createProductDataDto,
      ];
}
