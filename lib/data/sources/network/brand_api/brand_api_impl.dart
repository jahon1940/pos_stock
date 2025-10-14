part of 'brand_api.dart';

@LazySingleton(as: BrandApi)
class BrandApiImpl implements BrandApi {
  BrandApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  // ignore: unused_field
  final DioClient _dioClient;
}
