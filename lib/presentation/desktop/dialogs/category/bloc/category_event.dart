part of 'category_bloc.dart';

abstract class CategoryEvent {}

class GetCategory extends CategoryEvent {}

class GetCategoryId extends CategoryEvent {
  final int? id;
  GetCategoryId(this.id);
}

class CreateCategory extends CategoryEvent {
  final CreateCategoryRequest request;
  CreateCategory(this.request);
}

class PrintPrice extends CategoryEvent {
  final CreateCategoryRequest request;
  PrintPrice(this.request);
}

class UpdateCategory extends CategoryEvent {
  final String? id;
  final CreateCategoryRequest request;
  UpdateCategory(this.request, this.id);
}

class DeleteCategoryId extends CategoryEvent {
  final String? id;
  DeleteCategoryId(this.id);
}

class SelectedCategory extends CategoryEvent {
  final int? selectedCategory;
  SelectedCategory(this.selectedCategory);
}
