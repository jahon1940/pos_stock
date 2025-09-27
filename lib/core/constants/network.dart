class NetworkConstants {
  static String baseHostName = "kanstik";
  static const String apiVersion = 'v1';

  static String get baseUrl => 'https://$baseHostName.dev-retailer.hoomo.uz';
  static String get apiUrl => '$baseUrl/$apiVersion/stocks';
  static String get apiManagerUrl => '$baseUrl/$apiVersion/managers';
  static String get posUrl => '$baseUrl/$apiVersion/pos';
  static String get managerUrl => '$baseUrl/$apiVersion/managers';
  static String get login => '$posUrl/login';
  static String get posReceipt => '$posUrl/receipt';
  static String get posReportInfo => '$posUrl/receipt/info';
  static String get posManager => '$posUrl/managers';
  static String get stockReports => '$posUrl/stock-reports';
  static String get cart => '$apiUrl/mirel-cart';
  static String get cartProduct => '$cart/cart-products';
  static String cartDelete(int productId) => '$cartProduct/$productId/delete';
  static String updateDelete(int productId) =>
      '$cartProduct/$productId/products';
  static String get products => '$apiUrl/products';
  static String get productsUnsold => '$products/unsold';
  static String get productsLowDemand => '$products/low-demand';
  static String get productsInfo => '$products/info';
  static String get companies => '$apiUrl/companies';
  static String get companyBonuses => '$apiUrl/company-bonuses';
  static String get categoriesManagers => '$apiManagerUrl/categories';
  static String get addSuppliers => '$apiManagerUrl/suppliers';
  static String get addManagers => '$apiManagerUrl/managers';
  static String get addSupplies => '$apiManagerUrl/supplies';
  static String get addCurrency => '$apiManagerUrl/currency';
  static String get addProducts => '$apiManagerUrl/products-list';
  static String get updateBarcode => '$apiUrl/$product/update_barcode';
  static String product(int productId) => '$products/$productId';
  static String get search => '$products/search';
  static String get searchCompanies => '$companies/search';
  static String get searchCompanyBonuses => '$companyBonuses/search';
  static String get categories => '$apiUrl/categories';
  static String category(int categoryId) => '$categories/$categoryId';
  static String get brands => '$apiUrl/brands';
  static String brand(int brandId) => '$brands/$brandId';
  static String get stocks => '$apiUrl/stocks';
  static String get productInStocks => '$apiUrl/product-in-stocks';
  static String get regions => '$apiUrl/regions';
  static String get organizations => '$apiUrl/organizations';
  static String get eposUrl =>
      // kDebugMode
      // ? 'http://integration.epos.uz:8347/uzpos'
      // :
      'http://localhost:8347/uzpos';
  //static String get eposUrl => 'http://integration.epos.uz:8347/uzpos';
  static String get eposToken => 'DXJFX32CN1296678504F2';
  static String get posData => '$posUrl/current';
  static String get posSynchronize => '$posUrl/last-synchronize';
  static String get orderUrl => '$posUrl/orders';
  static String get posVersion => '$posUrl/versions/app-version';
  static String get appVersion => '$posUrl/versions/current-version';
  static String get posReports => '$posUrl/reports/download-excel';
  static String get contracts => '$apiUrl/contracts';
  static String get reserve => '$apiUrl/reserves';
  static String get specialDiscount => '$posUrl/discount';
  static String get discounts => '$posUrl/discount-types';
  static String get supplies => '$apiManagerUrl/supplies';
  static String get transfers => '$apiManagerUrl/stock-transfers';
  static String get writeOffs => '$apiManagerUrl/write-offs';
  static String get inventories => '$apiManagerUrl/inventories';
  static String get conduct => '$supplies1C/conduct-supply/1c';
  static String get supplies1C => '$apiManagerUrl/supplies-1c';
  static String get suppliers => '$apiManagerUrl/suppliers';
  static String get organizationsStock => '$apiManagerUrl/organizations';
  static String get managers => '$apiManagerUrl/managers';
  static String get exportProducts => '$addProducts/download-excel';
  static String get exportInventoryProducts => '$apiManagerUrl/products/stocks';
  static String get kvi => '$posUrl/product-kvi-discounts/calculate';

  static String get socket =>
      'wss://$baseHostName.retailer.hoomo.uz/ws/pos/orders/count/';
  static String updateChange(int id) =>
      '$posUrl/product-in-stocks/$id/update-change';

  static bool devMode = false;

  static void enableDevMode() {
    devMode = true;
    //baseUrl = 'https://kassa.dev-retailer.hoomo.uz';
  }

  static void disableDevMode() {
    devMode = false;
    //baseUrl = 'https://kanstik.retailer.hoomo.uzz';
  }
}
