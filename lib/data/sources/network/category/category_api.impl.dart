part of 'category_api.dart';

@LazySingleton(as: CategoryApi)
class CategoryApiImpl extends CategoryApi {
  CategoryApiImpl(
    this._dioClient,
  );

  final DioClient _dioClient;

  @override
  Future<void> createCategory(CreateCategoryRequest request) async {
    await _dioClient.postRequest(NetworkConstants.categoriesManagers, data: request.toJson());
  }

  @override
  Future<void> deleteCategory(
    String categoryId,
  ) async {
    await _dioClient.deleteRequest('${NetworkConstants.categoriesManagers}/$categoryId');
  }

  @override
  Future<CategoryDto?> getCategoryId(
    int categoryId,
  ) async {
    final res = await _dioClient.getRequest(
      '${NetworkConstants.categoriesManagers}/$categoryId',
      converter: (response) => CategoryDto.fromJson(response),
    );
    return res;
  }

  @override
  Future<PaginatedDto<CategoryDto>?> getCategory() async => _dioClient.getRequest(
        NetworkConstants.categoriesManagers,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => CategoryDto.fromJson(json),
        ),
      );

  @override
  Future<void> updateCategory({
    required String categoryCid,
    required Map<String, dynamic> data,
  }) async =>
      _dioClient.putRequest('${NetworkConstants.categoriesManagers}/$categoryCid', data: data);
}
