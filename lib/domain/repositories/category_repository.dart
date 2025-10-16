import 'package:injectable/injectable.dart';
import '../../data/dtos/category/category_dto.dart';
import '../../data/dtos/category/create_category_request.dart';
import '../../data/dtos/pagination_dto.dart';
import '../../data/sources/network/category/category_api.dart';

part '../../data/repositories/category_repository_impl.dart';

abstract class CategoryRepository {
  Future<CategoryDto?> getCategoryId(int categoryId);

  Future<PaginatedDto<CategoryDto>?> getCategory();

  Future<void> createCategory(CreateCategoryRequest request);

  Future<void> updateCategory({
    required String categoryCid,
    required Map<String, dynamic> data,
  });

  Future<void> deleteCategory(String categoryId);
}
