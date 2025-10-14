part of 'category_bloc.dart';

sealed class CategoryEvent {}

class GetCategory extends CategoryEvent {}

class GetCategoryId extends CategoryEvent {
  GetCategoryId(this.id);

  final int? id;
}

class CreateCategory extends CategoryEvent {
  CreateCategory(this.request);

  final CreateCategoryRequest request;
}

class UpdateCategory extends CategoryEvent {
  UpdateCategory(this.request, this.id);

  final String? id;
  final CreateCategoryRequest request;
}

class DeleteCategoryId extends CategoryEvent {
  DeleteCategoryId(this.id);

  final String? id;
}
