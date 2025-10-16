import 'package:injectable/injectable.dart';

import '../../../../core/constants/network.dart';
import '../../../../core/network/dio_client.dart';
import '../../../dtos/category/category_dto.dart';
import '../../../dtos/category/create_category_request.dart';
import '../../../dtos/pagination_dto.dart';

part 'category_api.impl.dart';

abstract class CategoryApi {
  Future<PaginatedDto<CategoryDto>?> getCategory();

  Future<CategoryDto?> getCategoryId(int categoryId);

  Future<void> createCategory(CreateCategoryRequest request);

  Future<void> updateCategory({
    required String categoryCid,
    required Map<String, dynamic> data,
  });

  Future<void> deleteCategory(String categoryId);
}
