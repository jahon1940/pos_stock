import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../data/dtos/country/country_dto.dart';
import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../domain/repositories/brand_repository.dart';

part 'country_state.dart';

part 'country_cubit.freezed.dart';

@injectable
class CountryCubit extends Cubit<CountryState> {
  CountryCubit(
    this._repo,
  ) : super(const CountryState());

  final BrandRepository _repo;

  Future<void> getCountries() async {}
}
