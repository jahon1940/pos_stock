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
    this.clearPrevious = false,
    this.stockId,
    this.categoryId,
    this.supplierId,
  });

  final String value;
  final int? stockId;
  final int? categoryId;
  final int? supplierId;
  final bool clearPrevious;
}

class CreateProductEvent extends SearchEvent {
  const CreateProductEvent(
    this.addProductRequest,
  );

  final CreateProductRequest addProductRequest;
}

class UpdateProductEvent extends SearchEvent {
  UpdateProductEvent({
    required this.context,
    required this.productId,
    required this.putProductRequest,
  });

  final BuildContext context;
  final int productId;
  final CreateProductRequest putProductRequest;
}

class DeleteProductEvent extends SearchEvent {
  DeleteProductEvent(this.productId);

  final int productId;
}

class AddCurrencyEvent extends SearchEvent {
  AddCurrencyEvent(this.addCurrencyRequest);

  final AddCurrencyRequest addCurrencyRequest;
}

class GetLocalProducts extends SearchEvent {}

class GetRemoteProducts extends SearchEvent {}

class NullRemoteProducts extends SearchEvent {}

class ExportProducts extends SearchEvent {}

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

class SelectSupplier extends SearchEvent {
  SelectSupplier({this.id});

  final int? id;
}

class SelectCategory extends SearchEvent {
  SelectCategory({this.id});

  final int? id;
}

class LoadMoreSearch extends SearchEvent {
  LoadMoreSearch({this.remote = false});

  final bool remote;
}

class InfoProducts extends SearchEvent {}
