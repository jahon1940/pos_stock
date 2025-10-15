part of '../../domain/repositories/brand_repository.dart';

@LazySingleton(as: BrandRepository)
class BrandRepositoryImpl implements BrandRepository {
  BrandRepositoryImpl(
    this._brandApi,
  );

  final BrandApi _brandApi;

  @override
  Future<void> createBrand(CreateBrandRequest request) => _brandApi.createBrand(request);

  @override
  Future<void> updateBrand({
    required Map<String, dynamic> data,
    required String brandCid,
  }) =>
      _brandApi.updateBrand(data: data, brandCid: brandCid);

  @override
  Future<PaginatedDto<BrandDto>?> getBrands() async => _brandApi.getBrands();
}
