import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/enums/states.dart';
import '../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../domain/repositories/organization_repository.dart';

part 'organization_state.dart';

part 'organization_cubit.freezed.dart';

@injectable
class OrganizationCubit extends Cubit<OrganizationState> {
  OrganizationCubit(
    this._organizationRepo,
  ) : super(const OrganizationState()) {
    getOrganizations();
  }

  final OrganizationRepository _organizationRepo;

  FutureOr<void> getOrganizations() async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final res = await _organizationRepo.getOrganizations();
      emit(state.copyWith(status: StateStatus.initial, organizations: res ?? []));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }
}
