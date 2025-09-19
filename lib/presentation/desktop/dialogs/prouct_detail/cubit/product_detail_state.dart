part of 'product_detail_cubit.dart';

@freezed
class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState({
    @Default(StateStatus.initial) StateStatus status,
    ProductDetailDto? productDetail,
  }) = _ProductDetailState;
}
