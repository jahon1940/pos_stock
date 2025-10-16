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
  const CreateCategoryEvent({
    required this.name,
    this.imageFile,
  });

  final String name;
  final File? imageFile;
}

class UpdateCategoryEvent extends CategoryEvent {
  const UpdateCategoryEvent({
    required this.categoryCid,
    required this.name,
    this.imageFile,
    this.deleteImage = false,
  });

  final String categoryCid;
  final String name;
  final File? imageFile;
  final bool deleteImage;
}

class DeleteCategoryIdEvent extends CategoryEvent {
  const DeleteCategoryIdEvent(
    this.id,
  );

  final String? id;
}
