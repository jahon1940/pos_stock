import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/transfers/transfer_product_request.dart';

part 'create_transfers.freezed.dart';
part 'create_transfers.g.dart';

@Freezed(fromJson: false, toJson: true)
class CreateTransfers with _$CreateTransfers {
  factory CreateTransfers({
    int? fromStockId,
    int? toStockId,
    List<TransferProductRequest>? products,
  }) = _CreateTransfers;
}
