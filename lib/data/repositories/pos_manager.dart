import 'package:hoomo_pos/data/dtos/pos_discount_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_special_discount_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/daos/poses_dao.dart';
import 'package:hoomo_pos/data/sources/network/pos_api.dart';
import 'package:hoomo_pos/domain/repositories/pos_manager.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PosManagerRepository)
class PosMangerImpl implements PosManagerRepository {
  final PosesDao _posesDao;
  final PosApi _posApi;

  PosMangerImpl(this._posesDao, this._posApi);

  @override
  Future<PosManagerDto> getPosManager() async{
    try {
      Poses? pos = await _posesDao.getPos();
      pos ??= await _posApi.getPos();
      return PosManagerDto.toDto(pos);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateLastSynchronize() async{
    try {
      await _posApi.updateLastSynchronize();
    } catch(_) {

    }
  }

  @override
  Future<PosSpecialDiscountDto> getPosSpecialDiscount() async{
    return await _posApi.getPosSpecialDiscount();
  }

  @override
  Future<List<PosDiscountDto>> getPosDiscounts() async{
    return await _posApi.getPosDiscounts();
  }
}
