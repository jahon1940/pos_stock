import 'package:hoomo_pos/data/dtos/pos_discount_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_special_discount_dto.dart';

abstract class PosManagerRepository {
  Future<PosManagerDto> getPosManager();
  Future<List<PosDiscountDto>> getPosDiscounts();
  Future<PosSpecialDiscountDto> getPosSpecialDiscount();
  Future<void> updateLastSynchronize();
}
