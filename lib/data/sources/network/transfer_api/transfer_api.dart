import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/transfers/create_transfers.dart';
import '../../../dtos/transfers/search_transfers.dart';
import '../../../dtos/transfers/transfer_dto.dart';
import '../../../dtos/transfers/transfer_product_dto.dart';

part 'transfer_api_impl.dart';

abstract class TransferApi {
  Future<PaginatedDto<TransferDto>> searchTransfers(SearchTransfers request);

  Future<void> createTransfers(CreateTransfers request);

  Future<List<TransferProductDto>> getTransfersProducts(int id);

  Future<void> deleteTransfers(int id);

  Future<void> downloadTransfers({required int id});
}
