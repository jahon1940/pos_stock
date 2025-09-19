import '../../data/dtos/category/category_dto.dart';
import '../../data/dtos/category/create_category_request.dart';
import '../../data/dtos/pagination_dto.dart';

abstract class CategoryRepository {
  Future<CategoryDto?> getCategoryId(int categoryId);

  Future<PaginatedDto<CategoryDto>?> getCategory();

  Future<void> createCategory(CreateCategoryRequest request);

  Future<void> updateCategory(String categoryId, CreateCategoryRequest request);

  Future<void> deleteCategory(String categoryId);
}
