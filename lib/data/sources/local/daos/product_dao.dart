import 'package:drift/drift.dart';
import 'package:hoomo_pos/core/logging/app_logger.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/product_param_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'package:hoomo_pos/data/sources/local/tables/product_data_table.dart';
import 'package:hoomo_pos/data/sources/local/tables/product_table.dart';
import 'package:injectable/injectable.dart';
import 'package:translit/translit.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [ProductsTable, CategoriesTable, ProductInStocksTable])
@lazySingleton
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(AppDatabase db) : super(db);

  int _totalPages = 1;
  int _totalCount = 0;

  int get totalPages => _totalPages;
  int get totalCount => _totalCount;

  /// Получение товаров с объединением данных из таблиц:
  /// - productsTable (продукт)
  /// - categoriesTable (категория, leftOuterJoin для возврата продукта без категории)
  /// - productInStocksTable (записи о количестве; агрегирование SUM для подсчёта общего количества и резерва)
  Future<PaginatedDto<ProductDto>> getPaginatedItems({
    int page = 1,
    int itemsPerPage = 100,
  }) async {
    // Правильный расчёт offset: на первой странице offset = 0
    final offset = (page - 1) * itemsPerPage;

    // Если общее количество не определено, получаем его и рассчитываем общее число страниц
    if (_totalCount == 0) {
      _totalCount = await getTotalItemCount() ?? 0;
      _totalPages = await getTotalPages(itemsPerPage: itemsPerPage);
    }

    // Формируем запрос с объединением таблиц
    final query = (select(productsTable).join([
      leftOuterJoin(
        categoriesTable,
        categoriesTable.id.equalsExp(productsTable.category),
      ),
      leftOuterJoin(
        productInStocksTable,
        productInStocksTable.product.equalsExp(productsTable.id),
      ),
    ])
      // Группируем по продукту для агрегации записей из productInStocksTable
      ..groupBy([productsTable.id])
      // Добавляем агрегированные колонки: суммарное количество и суммарное количество резерва
      ..addColumns([
        productInStocksTable.quantity,
        productInStocksTable.quantity_reserve,
      ])
      ..limit(itemsPerPage, offset: offset));

    // Выполняем запрос
    final joinedRows = await query.get();

    // Преобразуем каждую строку результата в DTO
    final results = joinedRows.map((row) {
      final product = row.readTable(productsTable);
      final category = row.readTableOrNull(categoriesTable);
      // Если записей о количестве нет, агрегатная функция возвращает null, поэтому подставляем 0
      final totalQuantity = row.read(productInStocksTable.quantity) ?? 0;
      final totalFreeQuantity =
          row.read(productInStocksTable.free_quantity) ?? 0;
      final totalQuantityReserve =
          row.read(productInStocksTable.quantity_reserve) ?? 0;

      return ProductDto.toDto(
        product,
        category: category,
        quantity: (totalFreeQuantity, totalQuantity, totalQuantityReserve),
      );
    }).toList();
    return PaginatedDto(
      results: results,
      pageNumber: page,
      pageSize: itemsPerPage,
      totalPages: _totalPages,
      count: _totalCount,
    );
  }

  /// Получение общего количества товаров
  Future<int?> getTotalItemCount() async {
    final countExp = productsTable.id.count();
    final query = selectOnly(productsTable)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp);
  }

  /// Расчёт общего количества страниц на основе количества записей и лимита на страницу
  Future<int> getTotalPages({int itemsPerPage = 20}) async {
    final totalCount = await getTotalItemCount();
    return ((totalCount ?? 0) / itemsPerPage).ceil();
  }


  Future<void> insertProducts(List<Products> product) async {
    try {
      // Process products to add transliterated fields
      final productsWithTranslit = product.map((p) => _addTransliteratedFields(p)).toList();

      await batch((batch) {
        batch.insertAll(productsTable, productsWithTranslit, mode: InsertMode.insertOrReplace);
      });

    } catch (e) {
      rethrow;
    }
  }

  /// Add transliterated versions of text fields to a product
  Products _addTransliteratedFields(Products product) {
    return product.copyWith(
      title_translit: Value(_transliterateField(product.title)),
      title_ru_translit: Value(_transliterateField(product.title_ru)),
      title_uz_translit: Value(_transliterateField(product.title_uz)),
      vendor_code_translit: Value(_transliterateField(product.vendor_code)),
    );
  }

  /// Helper method to safely transliterate a nullable field
  String? _transliterateField(String? field) {
    if (field == null || field.isEmpty) return null;

    try {
      // Store both transliterated versions for maximum search compatibility
      final toTranslit = Translit().toTranslit(source: field.toLowerCase());
      final unTranslit = Translit().unTranslit(source: field.toLowerCase());

      // Combine both transliterations to catch all possible search scenarios
      final combined = '$toTranslit $unTranslit'.trim();
      return combined.isEmpty ? null : combined;
    } catch (e) {
      appLogger.w('Error transliterating field "$field": $e');
      return field.toLowerCase(); // Fallback to original lowercase
    }
  }

  Future<List<Products>> getAll() async {
    return await (select(productsTable)).get();
  }

  Stream<List<Products>> productsInCategory(ProductParamDto? category) {
    if (category == null) {
      return (select(productsTable)..where((t) => isNull(t.category))).watch();
    } else {
      return (select(productsTable)
            ..where((t) => t.category.equals(category.id)))
          .watch();
    }
  }

  Stream<List<Products>> productsInBrand(ProductParamDto? brand) {
    if (brand == null) {
      return (select(productsTable)..where((t) => isNull(t.brand))).watch();
    } else {
      return (select(productsTable)..where((t) => t.brand.equals(brand.id)))
          .watch();
    }
  }

  Stream<List<Products>> productsInMadeIn(ProductParamDto? madeIn) {
    if (madeIn == null) {
      return (select(productsTable)..where((t) => isNull(t.made_in))).watch();
    } else {
      return (select(productsTable)..where((t) => t.made_in.equals(madeIn.id)))
          .watch();
    }
  }

  Stream<List<Products>> productsInFav() {
    return (select(productsTable)..where((t) => t.in_fav.equals(true))).watch();
  }

  Stream<List<Products>> productsInCart() {
    return (select(productsTable)..where((t) => t.in_cart.equals(true)))
        .watch();
  }

  Stream<List<Products>> productsInStopList() {
    return (select(productsTable)..where((t) => t.stop_list.equals(true)))
        .watch();
  }

  Stream<List<Products>> productsInPromotion() {
    return (select(productsTable)..where((t) => t.promotion.equals(true)))
        .watch();
  }

  Stream<List<Products>> productsInBestseller() {
    return (select(productsTable)..where((t) => t.bestseller.equals(true)))
        .watch();
  }

  Future<int> addProduct(Products product) {
    return into(productsTable).insert(product);
  }

  Future<bool> updateProduct(Products product) {
    return update(productsTable).replace(product);
  }

  Future<int> deleteProduct(Products product) {
    return delete(productsTable).delete(product);
  }

  Future<Products?> getProduct(int id) async {
    return await (select(productsTable)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<int> deleteAllProducts() {
    return delete(productsTable).go();
  }

  Future<void> addUpdateProduct(Products product) {
    final productWithTranslit = _addTransliteratedFields(product);
    return into(productsTable).insertOnConflictUpdate(productWithTranslit);
  }

  Future<void> updatePrice(int productId, num price) async {
    await (update(productsTable)..where((tbl) => tbl.id.equals(productId)))
        .write(ProductsTableCompanion(price: Value(price.toInt())));
  }


  /// Search products with pagination and transliteration support
  Future<PaginatedDto<ProductDto>> searchPaginatedItems({
    int page = 1,
    int itemsPerPage = 100,
    String? searchQuery,
    int? priceFilter,
  }) async {
    final String originalSearchValue = (searchQuery ?? '').trim().toLowerCase();
    final searchWords = originalSearchValue.split(' ').where((word) => word.isNotEmpty).toList();

    final offset = (page - 1) * itemsPerPage;
    var query = select(productsTable);

    if (priceFilter != null) {
      query = query
        ..where(
          (p) =>
              (p.price.isNotNull() &
                  p.price.isBiggerOrEqualValue(priceFilter)) |
              (p.purchase_price_uzs.isNotNull() &
                  p.purchase_price_uzs.isBiggerOrEqualValue(priceFilter)),
        );
    }

    if (priceFilter != null) {
      query.orderBy([
        (t) => OrderingTerm(
            expression: productsTable.price.equals(priceFilter),
            mode: OrderingMode.desc),
        (t) => OrderingTerm(
            expression: productsTable.price, mode: OrderingMode.asc),
      ]);
    }

    if (originalSearchValue.isNotEmpty) {
      query = query
        ..where(
          (p) {
            var condition =
                p.barcode.trim().lower().contains(originalSearchValue) |
                p.title.trim().lower().contains(originalSearchValue) |
                (p.title_ru.isNotNull() & p.title_ru.trim().lower().contains(originalSearchValue)) |
                (p.title_uz.isNotNull() & p.title_uz.trim().lower().contains(originalSearchValue)) |
                (p.title_translit.isNotNull() & p.title_translit.trim().lower().contains(originalSearchValue)) |
                (p.title_ru_translit.isNotNull() & p.title_ru_translit.trim().lower().contains(originalSearchValue)) |
                (p.title_uz_translit.isNotNull() & p.title_uz_translit.trim().lower().contains(originalSearchValue)) |
                (p.vendor_code.isNotNull() & p.vendor_code.trim().lower().contains(originalSearchValue)) |
                (p.vendor_code_translit.isNotNull() & p.vendor_code_translit.trim().lower().contains(originalSearchValue));

            if (searchWords.length > 1) {
              for (final word in searchWords) {
                if (word.length >= 2) {
                  condition = condition |
                      p.title.trim().lower().contains(word) |
                      (p.title_ru.isNotNull() & p.title_ru.trim().lower().contains(word)) |
                      (p.title_uz.isNotNull() & p.title_uz.trim().lower().contains(word)) |
                      (p.title_translit.isNotNull() & p.title_translit.trim().lower().contains(word)) |
                      (p.title_ru_translit.isNotNull() & p.title_ru_translit.trim().lower().contains(word)) |
                      (p.title_uz_translit.isNotNull() & p.title_uz_translit.trim().lower().contains(word));
                }
              }
            }

            return condition;
          },
        );
    }

    final newQuery = query.join([
      leftOuterJoin(
        categoriesTable,
        categoriesTable.id.equalsExp(productsTable.category),
      ),
      leftOuterJoin(
        productInStocksTable,
        productInStocksTable.product.equalsExp(productsTable.id),
      ),
    ])
      ..groupBy([productsTable.id])
      ..addColumns([
        productInStocksTable.quantity,
        productInStocksTable.quantity_reserve,
      ])
      ..limit(itemsPerPage, offset: offset);

    List<TypedResult> joinedRows = [];
    try {
      joinedRows = await newQuery.get();
    } catch (e) {
      appLogger.e('Error executing search query: $e');
    }

    final results = joinedRows.map((row) {
      final product = row.readTable(productsTable);
      final category = row.readTableOrNull(categoriesTable);
      final totalQuantity = row.read(productInStocksTable.quantity) ?? 0;
      final totalFreeQuantity =
          row.read(productInStocksTable.free_quantity) ?? 0;
      final totalQuantityReserve =
          row.read(productInStocksTable.quantity_reserve) ?? 0;
      return ProductDto.toDto(
        product,
        category: category,
        quantity: (totalFreeQuantity, totalQuantity, totalQuantityReserve),
      );
    }).toList();

    final totalCount = await getSearchItemCount(searchQuery: originalSearchValue);
    final totalPages = ((totalCount) / itemsPerPage).ceil();

    return PaginatedDto(
      results: results,
      pageNumber: page,
      pageSize: itemsPerPage,
      totalPages: totalPages,
      count: totalCount,
    );
  }

  /// Get count of search results
  Future<int> getSearchItemCount({required String searchQuery}) async {
    final String originalSearchValue = searchQuery.trim().toLowerCase();
    final searchWords = originalSearchValue.split(' ').where((word) => word.isNotEmpty).toList();

    var countQuery = selectOnly(productsTable)
      ..addColumns([productsTable.id.count()]);

    if (originalSearchValue.isNotEmpty) {
      var condition =
          productsTable.barcode.trim().lower().contains(originalSearchValue) |
          productsTable.title.trim().lower().contains(originalSearchValue) |
          (productsTable.title_ru.isNotNull() & productsTable.title_ru.trim().lower().contains(originalSearchValue)) |
          (productsTable.title_uz.isNotNull() & productsTable.title_uz.trim().lower().contains(originalSearchValue)) |
          (productsTable.title_translit.isNotNull() & productsTable.title_translit.trim().lower().contains(originalSearchValue)) |
          (productsTable.title_ru_translit.isNotNull() & productsTable.title_ru_translit.trim().lower().contains(originalSearchValue)) |
          (productsTable.title_uz_translit.isNotNull() & productsTable.title_uz_translit.trim().lower().contains(originalSearchValue)) |
          (productsTable.vendor_code.isNotNull() & productsTable.vendor_code.trim().lower().contains(originalSearchValue)) |
          (productsTable.vendor_code_translit.isNotNull() & productsTable.vendor_code_translit.trim().lower().contains(originalSearchValue));

      if (searchWords.length > 1) {
        for (final word in searchWords) {
          if (word.length >= 2) {
            condition = condition |
                productsTable.title.trim().lower().contains(word) |
                (productsTable.title_ru.isNotNull() & productsTable.title_ru.trim().lower().contains(word)) |
                (productsTable.title_uz.isNotNull() & productsTable.title_uz.trim().lower().contains(word)) |
                (productsTable.title_translit.isNotNull() & productsTable.title_translit.trim().lower().contains(word)) |
                (productsTable.title_ru_translit.isNotNull() & productsTable.title_ru_translit.trim().lower().contains(word)) |
                (productsTable.title_uz_translit.isNotNull() & productsTable.title_uz_translit.trim().lower().contains(word));
          }
        }
      }

      countQuery = countQuery..where(condition);
    }

    final result = await countQuery.getSingle();
    return result.read(productsTable.id.count()) ?? 0;
  }

  /// Backfill existing products with transliterated data after migration
  Future<void> backfillTransliteratedFields() async {
    try {
      final products = await (select(productsTable)
        ..where((p) => p.title_translit.isNull())
        ..limit(100)).get();

      if (products.isEmpty) {
        return;
      }

      await batch((batch) {
        for (final product in products) {
          final productWithTranslit = _addTransliteratedFields(product);
          batch.update(
            productsTable,
            productWithTranslit,
            where: (p) => p.id.equals(product.id),
          );
        }
      });

      final remainingCount = await (selectOnly(productsTable)
        ..addColumns([productsTable.id.count()])
        ..where(productsTable.title_translit.isNull())).getSingle();

      final remaining = remainingCount.read(productsTable.id.count()) ?? 0;
      if (remaining > 0) {
        await backfillTransliteratedFields();
      }

    } catch (e) {
      appLogger.e('Error during backfill: $e');
      rethrow;
    }
  }

}
