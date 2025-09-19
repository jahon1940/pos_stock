part of 'add_product_cubit.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState(
      {@Default(StateStatus.initial) StateStatus status,
      ProductDetailDto? product,
      int? categoryId}) = _AddProductState;
}
