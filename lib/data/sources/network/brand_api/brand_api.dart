import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/brand/create_brand_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/network.dart';
import '../../../dtos/brand/brand_dto.dart';
import '../../../dtos/pagination_dto.dart';

part 'brand_api_impl.dart';

abstract class BrandApi {
  Future<void> createBrand(CreateBrandRequest request);

  Future<PaginatedDto<BrandDto>?> getBrands();
}
