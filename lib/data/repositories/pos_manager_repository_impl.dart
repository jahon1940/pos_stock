part of '../../domain/repositories/pos_manager_repository.dart';

@LazySingleton(as: PosManagerRepository)
class PosManagerRepositoryImpl implements PosManagerRepository {
  PosManagerRepositoryImpl(
    this._posesDao,
    this._posApi,
  );

  final PosesDao _posesDao;
  final PosApi _posApi;

  @override
  Future<PosManagerDto> getPosManager() async {
    Poses? pos = await _posesDao.getPos();
    pos ??= await _posApi.getPos();
    return PosManagerDto.toDto(pos);
  }

  @override
  Future<void> updateLastSynchronize() async => _posApi.updateLastSynchronize();

  @override
  Future<PosSpecialDiscountDto> getPosSpecialDiscount() async => _posApi.getPosSpecialDiscount();

  @override
  Future<List<PosDiscountDto>> getPosDiscounts() async => _posApi.getPosDiscounts();
}
