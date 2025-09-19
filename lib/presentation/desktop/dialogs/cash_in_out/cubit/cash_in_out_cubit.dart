import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_params_dto.dart';
import 'package:hoomo_pos/domain/repositories/pos_manager.dart';
import 'package:hoomo_pos/domain/repositories/receipt.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:hoomo_pos/presentation/desktop/screens/shifts/cubit/shift_cubit.dart';
import 'package:injectable/injectable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'cash_in_out_state.dart';
part 'cash_in_out_cubit.freezed.dart';

@injectable
class CashInOutCubit extends Cubit<CashInOutState> {
  CashInOutCubit(this._receiptRepository, this._posManagerRepository)
      : super(CashInOutState());
  final ReceiptRepository _receiptRepository;
  final PosManagerRepository _posManagerRepository;

  Future<void> saveReceipt(
      int amount, String comment, String type, BuildContext context) async {
    final cubit = context.read<ShiftCubit>();
    PosManagerDto posManagerDto = await _posManagerRepository.getPosManager();
    ReceiptDto receiptDto = ReceiptDto(
        companyName: posManagerDto.pos?.stock?.organization?.name ?? "",
        companyAddress: posManagerDto.pos?.stock?.organization?.name ?? "",
        companyINN: posManagerDto.pos?.stock?.organization?.name ?? "",
        receiptType: type,
        saleManagerId: posManagerDto.id,
        staffName: posManagerDto.name,
        printerSize: 80,
        isSynced: false,
        sendSoliq: false,
        sendTo1C: false,
        receiptDateTime:
            FormatterService().reverseDateFormatter(DateTime.now()),
        params: ReceiptParamsDto(
            receivedCash: amount * 100,
            note: comment,
            receivedCard: 0,
            items: []));

    if (type == 'cash_in') {
      cubit.changeCashIn(amount * 100);
    } else {
      cubit.changeCashOut(amount * 100);
    }
    _receiptRepository.sendReceipt(receiptDto);
  }
}
