part of 'fast_search_bloc.dart';

@freezed
class FastSearchState with _$FastSearchState {
  const factory FastSearchState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<ProductDto>? products,
    PaginatedDto<ProductDetailDto>? mirelProducts,
    SearchRequest? request,
    int? priceLimit,
    @Default(true) bool isLocalSearch,
  }) = _FastSearchState;
}
