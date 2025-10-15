part of '../../domain/repositories/brand_repository.dart';

@LazySingleton(as: BrandRepository)
class BrandRepositoryImpl implements BrandRepository {
  BrandRepositoryImpl(
    this._brandApi,
  );

  final BrandApi _brandApi;

  @override
  Future<void> createBrand(
    CreateBrandRequest request,
  ) =>
      _brandApi.createBrand(request);

  @override
  Future<PaginatedDto<BrandDto>?> getBrands() async => _brandApi.getBrands();
}
