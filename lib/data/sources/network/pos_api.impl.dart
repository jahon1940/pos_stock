import 'package:dio/dio.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/pos_discount_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_special_discount_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/daos/poses_dao.dart';
import 'package:hoomo_pos/data/sources/network/pos_api.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PosApi)
class PosApiImpl implements PosApi {
  final DioClient _dioClient;
  final PosesDao _posesDao;

  PosApiImpl(this._dioClient, this._posesDao);

  @override
  Future<Poses> getPos({CancelToken? cancelToken}) async {
    try {
      final res = await _dioClient.getRequest<PosManagerDto>(
          NetworkConstants.posData,
          converter: (response) => PosManagerDto.fromJson(response),
          cancelToken: cancelToken);
      Poses pos = res.toPos();
      _posesDao.addPos(pos);
      return pos;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateLastSynchronize() async {
    try {
      await _dioClient.putRequest(NetworkConstants.posSynchronize);
    } catch (_) {}
  }

  @override
  Future<void> downloadReport(String date, String savePath) async {
    try {
      await _dioClient.downloadRequest(
          "${NetworkConstants.posReports}/$date", savePath);
    } catch (_) {}
  }

  @override
  Future<PosSpecialDiscountDto> getPosSpecialDiscount() async {
    try {
      return await _dioClient.getRequest<PosSpecialDiscountDto>(
          NetworkConstants.specialDiscount,
          converter: (response) => PosSpecialDiscountDto.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PosDiscountDto>> getPosDiscounts() async {
    try {
      return await _dioClient.getRequest<List<PosDiscountDto>>(
          NetworkConstants.discounts, converter: (response) {
        try {
          final List<dynamic> jsonList = response['results'] as List<dynamic>;
          return jsonList.map((json) => PosDiscountDto.fromJson(json)).toList();
        } catch (ex, s) {
          print(ex);
          print(s);
          rethrow;
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
