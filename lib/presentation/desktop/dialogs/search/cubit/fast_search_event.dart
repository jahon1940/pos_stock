part of 'fast_search_bloc.dart';

abstract class FastSearchEvent {}

class SearchTextChanged extends FastSearchEvent {
  final String value;
  final int? id;
  SearchTextChanged(this.value, {this.id});
}

class SearchInit extends FastSearchEvent {
  final bool isLocalSearch;

  SearchInit(this.isLocalSearch);
}

class LoadMoreSearch extends FastSearchEvent {}

class SetPriceLimit extends FastSearchEvent {
  final int? value;

  SetPriceLimit(this.value);
}

class UpdateCartState extends FastSearchEvent {
  final ProductDto product;

  UpdateCartState(this.product);
}
