import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_currency_request.freezed.dart';
part 'add_currency_request.g.dart';

@Freezed(fromJson: false, toJson: true)
class AddCurrencyRequest with _$AddCurrencyRequest {
  factory AddCurrencyRequest({
    int? priceUzsRate,
  }) = _AddCurrencyRequest;
}
