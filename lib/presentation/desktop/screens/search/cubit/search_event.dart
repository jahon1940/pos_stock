part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class SearchTextChangedEvent extends SearchEvent {
  SearchTextChangedEvent(this.value);

  final String value;
}

class SearchRemoteTextChangedEvent extends SearchEvent {
  SearchRemoteTextChangedEvent(
    this.value, {
    this.stockId,
    this.categoryId,
    this.supplierId,
  });

  final String value;
  final int? stockId;
  final int? categoryId;
  final int? supplierId;
}

class AddCurrencyEvent extends SearchEvent {
  AddCurrencyEvent(this.addCurrencyRequest);

  final AddCurrencyRequest addCurrencyRequest;
}

class GetLocalProducts extends SearchEvent {
  const GetLocalProducts();
}

class ExportProducts extends SearchEvent {
  const ExportProducts();
}

class ExportInventoryProducts extends SearchEvent {
  ExportInventoryProducts({
    this.id,
    this.categoryId,
  });

  final int? id;
  final int? categoryId;
}

class ExportProductPrice extends SearchEvent {
  ExportProductPrice({
    this.productId,
    this.quantity,
  });

  final int? productId;
  final int? quantity;
}

class SelectSupplierEvent extends SearchEvent {
  SelectSupplierEvent({this.id});

  final int? id;
}

class SelectCategoryEvent extends SearchEvent {
  SelectCategoryEvent({this.id});

  final int? id;
}

class LoadMoreSearchEvent extends SearchEvent {
  LoadMoreSearchEvent({this.remote = false});

  final bool remote;
}

class InfoProductsEvent extends SearchEvent {
  const InfoProductsEvent();
}
