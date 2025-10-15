part of 'category_bloc.dart';

sealed class CategoryEvent {
  const CategoryEvent();
}

class GetCategory extends CategoryEvent {
  const GetCategory();
}

class GetCategoryId extends CategoryEvent {
  const GetCategoryId(
    this.id,
  );

  final int? id;
}

class CreateCategoryEvent extends CategoryEvent {
  const CreateCategoryEvent(
    this.request,
  );

  final CreateCategoryRequest request;
}

class UpdateCategory extends CategoryEvent {
  const UpdateCategory(
    this.request,
    this.id,
  );

  final String? id;
  final CreateCategoryRequest request;
}

class DeleteCategoryId extends CategoryEvent {
  const DeleteCategoryId(
    this.id,
  );

  final String? id;
}
