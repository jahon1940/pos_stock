part of 'measure_api.dart';

@LazySingleton(as: MeasureApi)
class MeasureApiImpl implements MeasureApi {
  MeasureApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  // ignore: unused_field
  final DioClient _dioClient;
}
