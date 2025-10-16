part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default(StateStatus.initial) StateStatus status,
    PaginatedDto<ProductDto>? products,
    SearchRequest? request,
    CreateProductRequest? addProductRequest,
    CreateProductRequest? putProductRequest,
    AddCurrencyRequest? addCurrencyRequest,
  }) = _SearchState;
}
