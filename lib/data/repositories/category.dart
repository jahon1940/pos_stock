import 'package:injectable/injectable.dart';

import '../../domain/repositories/category.dart';
import '../dtos/category/category_dto.dart';
import '../dtos/category/create_category_request.dart';
import '../dtos/pagination_dto.dart';
import '../sources/network/category/category_api.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApi _CategoryApi;

  CategoryRepositoryImpl(this._CategoryApi);

  @override
  Future<void> createCategory(CreateCategoryRequest request) async {
    return await _CategoryApi.createCategory(request);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    return await _CategoryApi.deleteCategory(categoryId);
  }

  @override
  Future<PaginatedDto<CategoryDto>?> getCategory() async {
    return await _CategoryApi.getCategory();
  }

  @override
  Future<CategoryDto?> getCategoryId(int CategoryId) async {
    return await _CategoryApi.getCategoryId(CategoryId);
  }

  @override
  Future<void> updateCategory(
      String CategoryId, CreateCategoryRequest request) async {
    return await _CategoryApi.updateCategory(CategoryId, request);
  }
}
