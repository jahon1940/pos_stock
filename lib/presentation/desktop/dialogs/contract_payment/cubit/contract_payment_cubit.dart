import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/contract_payment/contract_payment_dto.dart';
import 'package:hoomo_pos/domain/repositories/contract_payment.dart';
import 'package:injectable/injectable.dart';

part 'contract_payment_state.dart';
part 'contract_payment_cubit.freezed.dart';

@injectable
class ContractPaymentCubit extends Cubit<ContractPaymentState> {
  ContractPaymentCubit(this._repository) : super(ContractPaymentState());

  final ContractPaymentRepository _repository;

  void init(int contractId) async {
    try {
      emit(state.copyWith(status: StateStatus.loading));

      final res = await _repository.getPayments(contractId);

      emit(state.copyWith(payments: res, status: StateStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
    }
  }
}
