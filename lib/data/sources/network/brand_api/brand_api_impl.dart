part of 'brand_api.dart';

@LazySingleton(as: BrandApi)
class BrandApiImpl implements BrandApi {
  BrandApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<void> createBrand(
    CreateBrandRequest request,
  ) async =>
      _dioClient.postRequest(NetworkConstants.brandsManagers, data: request.toJson());

  @override
  Future<void> updateBrand({
    required Map<String, dynamic> data,
    required String brandCid,
  }) async =>
      _dioClient.putRequest('${NetworkConstants.brandsManagers}/$brandCid', data: data);

  @override
  Future<PaginatedDto<BrandDto>?> getBrands() async => _dioClient.getRequest(
        NetworkConstants.brandsManagers,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => BrandDto.fromJson(json),
        ),
      );
}
