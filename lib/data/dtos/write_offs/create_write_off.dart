import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/add_product/add_product_request.dart';
import 'package:hoomo_pos/data/dtos/write_offs/write_off_product_request.dart';

part 'create_write_off.freezed.dart';
part 'create_write_off.g.dart';

@Freezed(fromJson: false, toJson: true)
class CreateWriteOff with _$CreateWriteOff {
  factory CreateWriteOff({
    int? stockId,
    List<WriteOffProductRequest>? products,
  }) = _CreateWriteOff;
}
