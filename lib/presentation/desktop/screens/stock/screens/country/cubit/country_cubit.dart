import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../../../../../../../data/dtos/country/country_dto.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../domain/repositories/country_repository.dart';

part 'country_state.dart';

part 'country_cubit.freezed.dart';

@injectable
class CountryCubit extends Cubit<CountryState> {
  CountryCubit(
    this._repo,
  ) : super(const CountryState());

  final CountryRepository _repo;

  Future<void> getCountries() async {
    if (state.status.isLoading) return;
    try {
      emit(state.copyWith(status: StateStatus.loading));
      final res = await _repo.getCountries();
      emit(state.copyWith(
        status: StateStatus.loaded,
        countries: res,
      ));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  Future<void> createCountry({
    required String name,
    required String fullName,
  }) async {
    if (state.createCountryStatus.isLoading) return;
    emit(state.copyWith(createCountryStatus: StateStatus.loading));
    try {
      await _repo.createCountry(data: {
        'cid': const Uuid().v4(),
        'name': name,
        'full_name': fullName,
      });
      final res = await _repo.getCountries();
      emit(state.copyWith(
        createCountryStatus: StateStatus.success,
        countries: res,
      ));
    } catch (e) {
      emit(state.copyWith(createCountryStatus: StateStatus.error));
    }
    emit(state.copyWith(createCountryStatus: StateStatus.initial));
  }

  Future<void> updateCountry({
    required String cid,
    required String name,
    required String fullName,
  }) async {
    if (state.createCountryStatus.isLoading) return;
    emit(state.copyWith(createCountryStatus: StateStatus.loading));
    try {
      // await _repo.updateBrand(
      //   brandCid: brandCid,
      //   data: {
      //     'name': name,
      //     if (deleteImage || base64.isNotNull) 'image': base64,
      //   },
      // );
      final res = await _repo.getCountries();
      emit(state.copyWith(
        createCountryStatus: StateStatus.success,
        countries: res,
      ));
    } catch (e) {
      emit(state.copyWith(createCountryStatus: StateStatus.error));
    }
    emit(state.copyWith(createCountryStatus: StateStatus.initial));
  }
}
