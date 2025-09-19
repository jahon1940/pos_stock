import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/pos_discount_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_special_discount_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

abstract class PosApi {
  Future<Poses> getPos({CancelToken? cancelToken});

  Future<List<PosDiscountDto>> getPosDiscounts();

  Future<PosSpecialDiscountDto> getPosSpecialDiscount();

  Future<void> updateLastSynchronize();

  Future<void> downloadReport(String date, String savePath);
}