part of '../../domain/repositories/measure_repository.dart';

@LazySingleton(as: MeasureRepository)
class MeasureRepositoryImpl implements MeasureRepository {
  MeasureRepositoryImpl(
    this._measureApi,
  );

  // ignore: unused_field
  final MeasureApi _measureApi;
}
