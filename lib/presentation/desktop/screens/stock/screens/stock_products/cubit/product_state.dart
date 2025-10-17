part of 'product_cubit.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    @Default(StateStatus.initial) StateStatus status,
    @Default(StateStatus.initial) StateStatus createProductStatus,
    ProductDetailDto? product,
    int? categoryId,
  }) = _ProductState;
}
