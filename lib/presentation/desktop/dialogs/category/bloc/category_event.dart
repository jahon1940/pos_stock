part of 'category_bloc.dart';

sealed class CategoryEvent {
  const CategoryEvent();
}

class GetCategoryEvent extends CategoryEvent {
  const GetCategoryEvent();
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

class UpdateCategoryEvent extends CategoryEvent {
  const UpdateCategoryEvent(
    this.request,
    this.id,
  );

  final String? id;
  final CreateCategoryRequest request;
}

class DeleteCategoryIdEvent extends CategoryEvent {
  const DeleteCategoryIdEvent(
    this.id,
  );

  final String? id;
}
