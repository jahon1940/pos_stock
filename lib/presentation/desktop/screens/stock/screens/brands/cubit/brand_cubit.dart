import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/mixins/image_mixin.dart';
import 'package:hoomo_pos/data/dtos/brand/brand_dto.dart';
import 'package:hoomo_pos/data/dtos/brand/create_brand_request.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../../../../../../../data/dtos/pagination_dto.dart';
import '../../../../../../../domain/repositories/brand_repository.dart';

part 'brand_state.dart';

part 'brand_cubit.freezed.dart';

@injectable
class BrandCubit extends Cubit<BrandState> with ImageMixin {
  BrandCubit(
    this._repo,
  ) : super(const BrandState());

  final BrandRepository _repo;

  Future<void> getBrands() async {
    if (state.status.isLoading) return;
    try {
      emit(state.copyWith(status: StateStatus.loading));
      final res = await _repo.getBrands();
      emit(state.copyWith(
        status: StateStatus.loaded,
        brands: res,
      ));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  Future<void> createBrand({
    required String name,
    final File? imageFile,
  }) async {
    if (state.createBrandStatus.isLoading) return;
    emit(state.copyWith(createBrandStatus: StateStatus.loading));
    try {
      String? base64;
      if (imageFile.isNotNull) {
        base64 = await fileToBase64(imageFile!);
        base64 = 'data:image/png;base64,$base64=';
      }
      await _repo.createBrand(
        CreateBrandRequest(
          cid: const Uuid().v4(),
          name: name,
          image: base64,
        ),
      );
      final res = await _repo.getBrands();
      emit(state.copyWith(
        createBrandStatus: StateStatus.success,
        brands: res,
      ));
    } catch (e) {
      emit(state.copyWith(createBrandStatus: StateStatus.error));
    }
    emit(state.copyWith(createBrandStatus: StateStatus.initial));
  }

  Future<void> updateBrand({
    required String brandCid,
    required String name,
    File? imageFile,
    bool deleteImage = false,
  }) async {
    if (state.createBrandStatus.isLoading) return;
    emit(state.copyWith(createBrandStatus: StateStatus.loading));
    try {
      String? base64;
      if (imageFile.isNotNull) {
        base64 = await fileToBase64(imageFile!);
        base64 = 'data:image/png;base64,$base64=';
      }
      await _repo.updateBrand(
        brandCid: brandCid,
        data: {
          'name': name,
          if (deleteImage || base64.isNotNull) 'image': base64,
        },
      );
      final res = await _repo.getBrands();
      emit(state.copyWith(
        createBrandStatus: StateStatus.success,
        brands: res,
      ));
    } catch (e) {
      emit(state.copyWith(createBrandStatus: StateStatus.error));
    }
    emit(state.copyWith(createBrandStatus: StateStatus.initial));
  }
}
