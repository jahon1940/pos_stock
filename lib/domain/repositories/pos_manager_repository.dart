import 'package:hoomo_pos/data/dtos/pos_discount_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_special_discount_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/daos/poses_dao.dart';
import 'package:hoomo_pos/data/sources/network/pos_api.dart';
import 'package:injectable/injectable.dart';

part '../../data/repositories/pos_manager_repository_impl.dart';

abstract class PosManagerRepository {
  Future<PosManagerDto> getPosManager();

  Future<List<PosDiscountDto>> getPosDiscounts();

  Future<PosSpecialDiscountDto> getPosSpecialDiscount();

  Future<void> updateLastSynchronize();
}
