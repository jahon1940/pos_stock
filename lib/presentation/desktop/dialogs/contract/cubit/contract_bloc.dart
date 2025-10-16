import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/contract_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/domain/repositories/contracts.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../domain/repositories/pos_manager_repository.dart';

part 'contract_state.dart';

part 'contract_event.dart';

part 'contract_bloc.freezed.dart';

@injectable
class ContractBloc extends Bloc<ContractEvent, ContractState> {
  ContractBloc(
    this._contractsRepository,
    this._posManagerRepository,
  ) : super(const ContractState()) {
    on<ContractLoad>(_onContractLoad, transformer: _debounce());
    on<CreateContractEvent>(_onCreateContract);
  }

  final ContractsRepository _contractsRepository;
  final PosManagerRepository _posManagerRepository;
  TextEditingController contractNumber = TextEditingController();
  TextEditingController contractDate = TextEditingController(
    text: DateFormat('dd.MM.yyyy').format(DateTime.now()),
  );
  String? contractType;
  int number = 0;
  int? contractId;

  EventTransformer<T> _debounce<T>() {
    return (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper);
  }

  Future<void> _onContractLoad(
    ContractLoad event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final res = await _contractsRepository.getContracts(event.companyId);
      PosManagerDto posManagerDto = await _posManagerRepository.getPosManager();
      emit(state.copyWith(status: StateStatus.loaded, posManagerDto: posManagerDto, contracts: res));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error, errorText: e.toString()));
    }
  }

  Future<void> _onCreateContract(
    CreateContractEvent event,
    Emitter<ContractState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      if (contractId == null) {
        await _contractsRepository.createContract(event.contractNum, event.contractDate, event.companyId);
      } else {
        await _contractsRepository.updateContract(event.contractNum, event.contractDate, event.companyId, contractId!);
      }

      contractDate.clear();
      contractNumber.clear();
      number = 0;
      generateContractNumber();
    } catch (ex) {
      emit(state.copyWith(status: StateStatus.error, errorText: ex.toString()));
    }
    add(ContractLoad(event.companyId));
  }

  void updateContract(ContractDto contract) {
    contractId = contract.id;
    print(contractId);
    contractNumber.text = contract.number ?? contract.name ?? '';
    contractDate.text = DateFormat('dd.MM.yyyy').format(DateTime.tryParse(contract.date ?? '') ?? DateTime.now());
  }

  generateContractNumber() {
    if (number == 0) {
      number = Random().nextInt(1000);
    }
    contractNumber.text = '$number от ${contractDate.text}';
  }
}
