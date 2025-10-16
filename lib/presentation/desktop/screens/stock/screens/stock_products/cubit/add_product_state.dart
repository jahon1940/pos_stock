part of 'add_product_cubit.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState({
    @Default(StateStatus.initial) StateStatus status,
    @Default(StateStatus.initial) StateStatus createProductStatus,
    ProductDetailDto? product,
    int? categoryId,
  }) = _AddProductState;
}
