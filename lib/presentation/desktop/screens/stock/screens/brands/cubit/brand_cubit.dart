import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/brand/brand_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../domain/repositories/brand_repository.dart';

part 'brand_state.dart';

part 'brand_cubit.freezed.dart';

@injectable
class BrandCubit extends Cubit<BrandState> {
  BrandCubit(
    this._repo,
  ) : super(const BrandState());

  final BrandRepository _repo;

  Future<void> getBrands() async {}
}
