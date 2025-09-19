part of 'un_sale_products_cubit.dart';

@freezed
class UnSaleProductsState with _$UnSaleProductsState {
  const factory UnSaleProductsState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<ProductDto>? products,
    @Default(0) int page
  }) = _UnSaleProductsState;
}
