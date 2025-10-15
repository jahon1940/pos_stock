import 'package:injectable/injectable.dart';

import '../../data/dtos/brand/brand_dto.dart';
import '../../data/dtos/brand/create_brand_request.dart';
import '../../data/dtos/pagination_dto.dart';
import '../../data/sources/network/brand_api/brand_api.dart';

part '../../data/repositories/brand_repository_impl.dart';

abstract class BrandRepository {
  Future<void> createBrand(CreateBrandRequest request);

  Future<void> updateBrand({
    required Map<String, dynamic> data,
    required String brandCid,
  });

  Future<PaginatedDto<BrandDto>?> getBrands();
}
