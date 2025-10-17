part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    this.isUpdated = false,
    this.status = StateStatus.loading,
    this.products,
    this.request,
  });

  final bool isUpdated;
  final StateStatus status;
  final PaginatedDto<ProductDto>? products;
  final SearchRequest? request;

  SearchState copyWith({
    StateStatus? status,
    PaginatedDto<ProductDto>? products,
    SearchRequest? request,
  }) =>
      SearchState(
        isUpdated: !isUpdated,
        status: status ?? this.status,
        products: products ?? this.products,
        request: request ?? this.request,
      );

  @override
  List<Object?> get props => [
        isUpdated,
        status,
        products,
        request,
      ];
}
