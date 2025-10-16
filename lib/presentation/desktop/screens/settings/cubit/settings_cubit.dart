import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/enums/table_type.dart';
import 'package:hoomo_pos/core/logging/app_logger.dart';
import 'package:hoomo_pos/core/styles/theme_provider.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/sources/local/daos/product_dao.dart';
import 'package:hoomo_pos/data/sources/local/daos/product_params_dao.dart';
import 'package:hoomo_pos/domain/repositories/companies.dart';
import 'package:hoomo_pos/domain/repositories/params.dart';
import 'package:hoomo_pos/domain/repositories/pos_manager.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
      this._productsRepository,
      this._companiesRepository,
      this._paramsRepository,
      this._posManagerRepository,
      ) : super(SettingsState());

  final ProductsRepository _productsRepository;
  final CompaniesRepository _companiesRepository;
  final ParamsRepository _paramsRepository;
  final PosManagerRepository _posManagerRepository;

  CancelToken? _cancelToken;

  void init(TableType tableType) async {
    final lastSynchronization =
    await _productsRepository.getLastSynchronizationTime();

    int productsCount = await _productsRepository.getProductsTotalCount();
    int productInStockCount =
    await _productsRepository.getProductInStocksTotalCount();

    final PosManagerDto posManagerDto =
    await _posManagerRepository.getPosManager();
    final packageInfo = await PackageInfo.fromPlatform();

    emit(state.copyWith(
        tableType: tableType,
        lastSynchronization: lastSynchronization,
        posManagerDto: posManagerDto,
        productInStocksCount: productInStockCount,
        productsCount: productsCount,
        version: packageInfo.version));
  }

  Future<void> synchronize() async {
    emit(state.copyWith(status: StateStatus.loading));
    await switch (state.tableType) {
      TableType.products => synchronizeProducts(),
      TableType.companies => synchronizeCompanies(),
      TableType.categories => throw UnimplementedError(),
      TableType.brands => throw UnimplementedError(),
    };
    await _posManagerRepository.updateLastSynchronize();

    int productsCount = await _productsRepository.getProductsTotalCount();
    int productInStockCount =
    await _productsRepository.getProductInStocksTotalCount();

    appLogger.i("SYNCHRONIZE DATA $productsCount/$productInStockCount");

    emit(state.copyWith(
        status: StateStatus.loaded,
        productInStocksCount: productInStockCount,
        productsCount: productsCount));
  }

  Future<void> synchronizeProducts() async {
    appLogger.i("SYNCHRONIZE...");
    await getIt<ProductParamsDao>().deleteAllProductInStoks();
    await getIt<ProductsDao>().deleteAllProducts();

    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    double totalSteps = 0;
    double currentStep = 0;

    // Получаем количество страниц для всех запросов
    final regions = await _paramsRepository.getRegions(1);
    final stocks = await _paramsRepository.getStocks(1);
    final brands = await _paramsRepository.getBrands(1);
    final categories = await _paramsRepository.getCategories(1);
    final organizations = await _paramsRepository.getOrganizations(1);
    final productStocks = await _paramsRepository.getProductInStocks(1);
    final syncRes = await _productsRepository.synchronize(1,
        cancelToken: _cancelToken); // выполняем сразу

    // Считаем общее количество шагов
    totalSteps = (regions.$2 +
        stocks.$2 +
        brands.$2 +
        categories.$2 +
        organizations.$2 +
        productStocks.$2 +
        syncRes.$2)
        .toDouble();

    void updateProgress() {
      _updateProgress((currentStep / totalSteps) * 100);
    }

    Future<void> runPaged(int totalPages, Future<void> Function(int page) call,
        {int start = 1}) async {
      for (var i = start; i <= totalPages; i++) {
        await call(i);
        currentStep++;
        updateProgress();
      }
    }

    await runPaged(regions.$2, _paramsRepository.getRegions);
    await runPaged(stocks.$2, _paramsRepository.getStocks);
    await runPaged(brands.$2, _paramsRepository.getBrands);
    await runPaged(categories.$2, _paramsRepository.getCategories);
    await runPaged(organizations.$2, _paramsRepository.getOrganizations);
    await runPaged(productStocks.$2, _paramsRepository.getProductInStocks);

    currentStep++; // уже был вызван synchronize(1)
    updateProgress();

    await runPaged(syncRes.$2, _productsRepository.synchronize,
        start: 2); // начиная со 2й страницы

    _updateProgress(100);
    final date = DateTime.now();
    await _productsRepository.setLastSynchronizationTime(date);
    emit(state.copyWith(lastSynchronization: date));
  }

  Future<void> synchronizeCompanies() async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    final res =
    await _companiesRepository.synchronize(1, cancelToken: _cancelToken);

    for (var i = 2; i < res.$2; i++) {
      final progress = i / res.$2 * 100;
      _updateProgress(progress);
      await _companiesRepository.synchronize(i);
    }

    _updateProgress(100);
  }

  void _updateProgress(double value) {
    emit(state.copyWith(progress: value.ceil()));
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }

  void changeTheme(ThemeProvider themeProvider) {
    themeProvider.toggleTheme();
    emit(state.copyWith(isChange: !state.isChange));
  }

  void changeLanguage() {
    emit(state.copyWith(isChange: !state.isChange));
  }

  void changeDevMode(BuildContext context) {
    if (NetworkConstants.devMode) {
      NetworkConstants.disableDevMode();
    } else {
      NetworkConstants.enableDevMode();
    }
    Phoenix.rebirth(context);
  }
}

