import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/daos/product_params_dao.dart';
import 'package:hoomo_pos/data/sources/network/params_api.dart';
import 'package:hoomo_pos/domain/repositories/params.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ParamsRepository)
class ParamsRepositoryImpl implements ParamsRepository {
  final ParamsApi _api;
  final ProductParamsDao _productParamsDao;

  ParamsRepositoryImpl(this._api, this._productParamsDao);

  @override
  Future<(int, int)> getBrands(int page) async {
    try {
      final res = await _api.getBrands(page);
      await _productParamsDao.insertBrands(res.results
          .map((e) => Brads(
                id: e.id,
                name: e.name ?? '',
                image_url: e.imageUrl,
              ))
          .toList());

      return (res.pageNumber, res.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(int, int)> getCategories(int page) async {
    try {
      final res = await _api.getCategories(page);
      await _productParamsDao.insertCategories(res.results
          .map((e) => Categories(
                id: e.id,
                name: e.name ?? '',
                image_url: e.imageUrl,
              ))
          .toList());
      return (res.pageNumber, res.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(int, int)> getOrganizations(int page) async {
    try {
      final res = await _api.getOrganizations(page);
      await _productParamsDao.insertOrganizations(res.results
          .map((e) => Organizations(
                id: e.id,
                name: e.name ?? '',
              ))
          .toList());
      return (res.pageNumber, res.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(int, int)> getProductInStocks(int page, {String? receiptId}) async {
    try {
      final res = await _api.getProductInStocks(page, receiptId: receiptId);
      await _productParamsDao.insertProductInStocks(res.results
          .map(
            (e) => ProductInStock(
              id: e.id,
              product: e.product,
              stock: e.stock?.id,
              free_quantity: e.freeQuantity,
              quantity: e.quantity,
              quantity_reserve: e.quantityReserve,
            ),
          )
          .toList());
      return (res.pageNumber, res.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(int, int)> getRegions(int page) async {
    try {
      final res = await _api.getRegions(page);
      await _productParamsDao.insertRegions(res.results
          .map((e) => Regions(
                id: e.id,
                name: e.name ?? '',
              ))
          .toList());
      return (res.pageNumber, res.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(int, int)> getStocks(int page) async {
    try {
      final res = await _api.getStocks(page);
      await _productParamsDao.insertStocks(res.results
          .map((e) => Stocks(
                id: e.id,
                name: e.name ?? '',
              ))
          .toList());
      return (res.pageNumber, res.totalPages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProductInStocks(ProductInStock productInStock) async {
    try {
      await _productParamsDao.updateProductInStock(productInStock);
      await _api.updateProductInStock(productInStock.id);
    } catch (e) {
      rethrow;
    }
  }
}
