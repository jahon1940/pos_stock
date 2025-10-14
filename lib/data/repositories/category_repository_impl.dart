part of '../../domain/repositories/category_repository.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(
    this._categoryApi,
  );

  final CategoryApi _categoryApi;

  @override
  Future<void> createCategory(
    CreateCategoryRequest request,
  ) async =>
      _categoryApi.createCategory(request);

  @override
  Future<void> deleteCategory(
    String categoryId,
  ) async =>
      _categoryApi.deleteCategory(categoryId);

  @override
  Future<PaginatedDto<CategoryDto>?> getCategory() async => _categoryApi.getCategory();

  @override
  Future<CategoryDto?> getCategoryId(
    int categoryId,
  ) async =>
      _categoryApi.getCategoryId(categoryId);

  @override
  Future<void> updateCategory(
    String categoryId,
    CreateCategoryRequest request,
  ) async =>
      _categoryApi.updateCategory(categoryId, request);
}
