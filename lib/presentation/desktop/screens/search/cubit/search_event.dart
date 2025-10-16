part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchTextChanged extends SearchEvent {
  final String value;

  SearchTextChanged(this.value);
}

class SearchRemoteTextChanged extends SearchEvent {
  final String value;
  final int? stockId;
  final int? categoryId;
  final int? supplierId;
  final bool clearPrevious;

  SearchRemoteTextChanged(
    this.value, {
    this.clearPrevious = false,
    this.stockId,
    this.categoryId,
    this.supplierId,
  });
}

class AddProductEvent extends SearchEvent {
  AddProductEvent(this.addProductRequest);

  final AddProductRequest addProductRequest;
}

class PutProduct extends SearchEvent {
  final AddProductRequest putProductRequest;
  final int productId;
  final BuildContext context;

  PutProduct(this.putProductRequest, this.productId, this.context);
}

class DeleteProduct extends SearchEvent {
  final int productId;

  DeleteProduct(this.productId);
}

class AddCurrency extends SearchEvent {
  final AddCurrencyRequest addCurrencyRequest;

  AddCurrency(this.addCurrencyRequest);
}

class GetLocalProducts extends SearchEvent {}

class GetRemoteProducts extends SearchEvent {}

class NullRemoteProducts extends SearchEvent {}

class ExportProducts extends SearchEvent {}

class ExportInventoryProducts extends SearchEvent {
  final int? id;
  final int? categoryId;

  ExportInventoryProducts({
    this.id,
    this.categoryId,
  });
}

class ExportProductPrice extends SearchEvent {
  final int? productId;
  final int? quantity;

  ExportProductPrice({
    this.productId,
    this.quantity,
  });
}

class SelectSupplier extends SearchEvent {
  final int? id;

  SelectSupplier({this.id});
}

class SelectCategory extends SearchEvent {
  final int? id;

  SelectCategory({this.id});
}

class LoadMoreSearch extends SearchEvent {
  final bool remote;

  LoadMoreSearch({this.remote = false});
}

class InfoProducts extends SearchEvent {}
