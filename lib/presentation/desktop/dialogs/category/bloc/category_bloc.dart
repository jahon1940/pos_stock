import 'dart:io' show File;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/mixins/image_mixin.dart';
import 'package:hoomo_pos/data/dtos/category/create_category_request.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart' show Uuid;
import '../../../../../data/dtos/category/category_dto.dart';
import '../../../../../domain/repositories/category_repository.dart';

part 'category_state.dart';

part 'category_event.dart';

part 'category_bloc.freezed.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> with ImageMixin {
  CategoryBloc(
    this._categoryRepository,
  ) : super(const CategoryState()) {
    on<CategoryEvent>(
      (event, emit) async => switch (event) {
        GetCategoryEvent _ => _getCategory(event, emit),
        GetCategoryId _ => _getCategoryId(event, emit),
        CreateCategoryEvent _ => _createCategory(event, emit),
        UpdateCategoryEvent _ => _updateCategory(event, emit),
        DeleteCategoryIdEvent _ => _deleteId(event, emit),
      },
    );
  }

  final CategoryRepository _categoryRepository;

  Future<void> _getCategory(
    GetCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.status.isLoading) return;
    try {
      emit(state.copyWith(status: StateStatus.loading));
      final res = await _categoryRepository.getCategory();
      emit(state.copyWith(
        status: StateStatus.loaded,
        categories: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _getCategoryId(
    GetCategoryId event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.status.isLoading) return;
    try {
      emit(state.copyWith(status: StateStatus.loading));
      final res = await _categoryRepository.getCategoryId(event.id!);
      emit(state.copyWith(
        status: StateStatus.loaded,
        category: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _createCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.createCategoryStatus.isLoading) return;
    emit(state.copyWith(createCategoryStatus: StateStatus.loading));
    try {
      String? base64;
      if (event.imageFile.isNotNull) {
        base64 = await fileToBase64(event.imageFile!);
      }
      await _categoryRepository.createCategory(
        CreateCategoryRequest(
          name: event.name,
          cid: const Uuid().v4(),
          active: true,
          image: base64 == null ? null : 'data:image/png;base64,$base64=',
        ),
      );
      final res = await _categoryRepository.getCategory();
      emit(state.copyWith(
        createCategoryStatus: StateStatus.success,
        categories: res,
      ));
    } catch (e) {
      emit(state.copyWith(createCategoryStatus: StateStatus.error));
    }
    emit(state.copyWith(createCategoryStatus: StateStatus.initial));
  }

  Future<void> _updateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.createCategoryStatus.isLoading) return;
    emit(state.copyWith(createCategoryStatus: StateStatus.loading));
    try {
      String? base64;
      if (event.imageFile.isNotNull) {
        base64 = await fileToBase64(event.imageFile!);
        base64 = 'data:image/png;base64,$base64=';
      }
      await _categoryRepository.updateCategory(
        categoryCid: event.categoryCid,
        data: {
          'name': event.name,
          if (event.deleteImage || base64.isNotNull) 'image': base64,
        },
      );
      final res = await _categoryRepository.getCategory();
      emit(state.copyWith(
        createCategoryStatus: StateStatus.success,
        categories: res,
      ));
    } catch (e) {
      emit(state.copyWith(createCategoryStatus: StateStatus.error));
    }
    emit(state.copyWith(createCategoryStatus: StateStatus.initial));
  }

  Future<void> _deleteId(
    DeleteCategoryIdEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      emit(state.copyWith(status: StateStatus.loading));
      await _categoryRepository.deleteCategory(event.id!);
      final res = await _categoryRepository.getCategory();
      emit(state.copyWith(
        status: StateStatus.loaded,
        categories: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
