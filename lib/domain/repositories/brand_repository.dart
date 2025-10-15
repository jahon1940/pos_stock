import 'package:hoomo_pos/data/dtos/brand/create_brand_request.dart';
import 'package:injectable/injectable.dart';

import '../../data/sources/network/brand_api/brand_api.dart';

part '../../data/repositories/brand_repository_impl.dart';

abstract class BrandRepository {
  Future<void> createBrand(CreateBrandRequest request);
}
