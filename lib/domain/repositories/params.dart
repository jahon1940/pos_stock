import 'package:hoomo_pos/data/sources/app_database.dart';

abstract class ParamsRepository {
  Future<(int, int)> getCategories(int page);

  Future<(int, int)> getBrands(int page);

  Future<(int, int)> getStocks(int page);

  Future<(int, int)> getRegions(int page);

  Future<(int, int)> getProductInStocks(int page, {String? receiptId});

  Future<(int, int)> getOrganizations(int page);

  Future<void> updateProductInStocks(ProductInStock productInStock);
}
