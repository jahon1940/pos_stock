import 'package:flutter/foundation.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/sources/network/transfer_api/transfer_api.dart';
import 'package:injectable/injectable.dart';

import '../../data/dtos/transfers/create_transfers.dart';
import '../../data/dtos/transfers/search_transfers.dart';
import '../../data/dtos/transfers/transfer_dto.dart';
import '../../data/dtos/transfers/transfer_product_dto.dart';

part '../../data/repositories/transfer_repository_impl.dart';

abstract class TransferRepository {
  Future<void> createTransfers(CreateTransfers request);

  Future<List<TransferProductDto>> getTransfersProducts(int id);

  Future<PaginatedDto<TransferDto>> searchTransfers(SearchTransfers request);

  Future<void> deleteTransfers(int id);

  Future<void> downloadTransfers({required int id});
}
