import '../../../dtos/category/category_dto.dart';
import '../../../dtos/category/create_category_request.dart';
import '../../../dtos/pagination_dto.dart';

abstract class CategoryApi {
  Future<PaginatedDto<CategoryDto>?> getCategory();

  Future<CategoryDto?> getCategoryId(int categoryId);

  Future<void> createCategory(CreateCategoryRequest request);

  Future<void> updateCategory(String categoryId, CreateCategoryRequest request);

  Future<void> deleteCategory(String categoryId);
}
