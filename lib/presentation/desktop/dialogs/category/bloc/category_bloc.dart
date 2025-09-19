import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/category/create_category_request.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/domain/repositories/category.dart';
import 'package:hoomo_pos/domain/repositories/companies.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../data/dtos/add_user/add_user_request.dart';
import '../../../../../data/dtos/category/category_dto.dart';

part 'category_state.dart';

part 'category_event.dart';

part 'category_bloc.freezed.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc(this._categoryRepository) : super(CategoryState()) {
    on<GetCategory>(_getCategory);
    on<GetCategoryId>(_getCategoryId);
    on<CreateCategory>(_createCategory);
    on<UpdateCategory>(_updateCategory);
    on<DeleteCategoryId>(_deleteId);
  }

  Future<void> _getCategory(
      GetCategory event, Emitter<CategoryState> emit) async {
    if (state.status == StateStatus.loading) return;

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
      GetCategoryId event, Emitter<CategoryState> emit) async {
    if (state.status == StateStatus.loading) return;

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
      CreateCategory event, Emitter<CategoryState> emit) async {
    if (state.status == StateStatus.loading) return;

    try {
      emit(state.copyWith(status: StateStatus.loading));

      await _categoryRepository.createCategory(event.request);
      add(GetCategory());
      emit(state.copyWith(
        status: StateStatus.loaded,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _updateCategory(
      UpdateCategory event, Emitter<CategoryState> emit) async {
    if (state.status == StateStatus.loading) return;

    try {
      emit(state.copyWith(status: StateStatus.loading));

      final res =
          await _categoryRepository.updateCategory(event.id!, event.request);
      add(GetCategory());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _deleteId(
      DeleteCategoryId event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    print(event.id);
    try {
      emit(state.copyWith(status: StateStatus.loading));

      await _categoryRepository.deleteCategory(event.id!);
      add(GetCategory());
      emit(state.copyWith(
        status: StateStatus.loaded,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
