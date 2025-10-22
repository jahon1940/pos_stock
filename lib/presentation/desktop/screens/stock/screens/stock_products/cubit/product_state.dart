part of 'product_cubit.dart';

class ProductState extends Equatable {
  final bool isUpdated;

  const ProductState({
    this.isUpdated = false,
    this.productPageData = const PaginatedDto(
      results: [],
      pageNumber: 1,
      pageSize: 50,
      totalPages: 1,
      count: 1,
    ),
    this.status = StateStatus.initial,
    this.createProductStatus = StateStatus.initial,
    this.createProductDataDto = const CreateProductDataDto(),
    this.isProductDataLoaded = false,
  });

  final PaginatedDto<ProductDto> productPageData;
  final StateStatus status;
  final StateStatus createProductStatus;
  final CreateProductDataDto createProductDataDto;
  final bool isProductDataLoaded;

  ProductState copyWith({
    PaginatedDto<ProductDto>? productPageData,
    StateStatus? status,
    StateStatus? createProductStatus,
    CreateProductDataDto? createProductDataDto,
    bool? isProductDataLoaded,
  }) =>
      ProductState(
        isUpdated: !isUpdated,
        productPageData: productPageData ?? this.productPageData,
        status: status ?? this.status,
        createProductStatus: createProductStatus ?? this.createProductStatus,
        createProductDataDto: createProductDataDto ?? this.createProductDataDto,
        isProductDataLoaded: isProductDataLoaded ?? false,
      );

  @override
  List<Object?> get props => [
        isUpdated,
        productPageData,
        status,
        createProductStatus,
        createProductDataDto,
        isProductDataLoaded,
      ];

  List<ProductDto> get pageProducts {
    if (productPageData.results.isEmpty) return [];
    final d = productPageData;
    // final start = (d.pageNumber - 1) * d.pageSize;
    final start = 0;
    final end = start + d.pageSize;
    return d.results.sublist(start, min(end, d.results.length)).toList();
  }
}
