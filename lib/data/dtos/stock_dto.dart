import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/region_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';
import 'organization_dto.dart';

part 'stock_dto.freezed.dart';
part 'stock_dto.g.dart';

@freezed
class StockDto with _$StockDto {
  const StockDto._();

  factory StockDto({
    required int id,
    required String name,
    String? address,
    String? phoneNumber,
    RegionDto? region,
    OrganizationDto? organization,
  }) = _StockDto;

  factory StockDto.fromJson(Map<String, dynamic> json) =>
      _$StockDtoFromJson(json);

  static StockDto fromTable(Stocks stock) => StockDto(
        id: stock.id,
        name: stock.name,
      );
}
