part of '../../domain/repositories/brand_repository.dart';

@LazySingleton(as: BrandRepository)
class BrandRepositoryImpl implements BrandRepository {
  BrandRepositoryImpl(
    this._brandApi,
  );

  // ignore: unused_field
  final BrandApi _brandApi;
}
