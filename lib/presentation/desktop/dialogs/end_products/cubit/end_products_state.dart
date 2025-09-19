part of 'end_products_cubit.dart';

@freezed
class EndProductsState with _$EndProductsState {
  const factory EndProductsState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<ProductDto>? products,
    @Default(0) int page
  }) = _EndProductsState;
}
