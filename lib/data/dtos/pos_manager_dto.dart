import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/organization_dto.dart';
import 'package:hoomo_pos/data/dtos/payment_type_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_dto.dart';
import 'package:hoomo_pos/data/dtos/region_dto.dart';
import 'package:hoomo_pos/data/dtos/stock_dto.dart';
import 'package:hoomo_pos/data/sources/app_database.dart';

part 'pos_manager_dto.freezed.dart';

part 'pos_manager_dto.g.dart';

@freezed
class PosManagerDto with _$PosManagerDto {
  const PosManagerDto._();

  factory PosManagerDto(
      {required int id,
      required String name,
      String? position,
      String? username,
      String? role,
      PosDto? pos}) = _PosManagerDto;

  factory PosManagerDto.fromJson(Map<String, dynamic> json) =>
      _$PosManagerDtoFromJson(json);

  Poses toPos() => Poses(
      id: id,
      name: name,
      gnk_id: pos?.gnk_id,
      role: role,
      username: username,
      position: position,
      enable_no_fiscal_sale: pos?.enable_no_fiscal_sale,
      integration_with_1c: pos?.integration_with_1c,
      manager_sale: pos?.manager_sale,
      payment_dollar: pos?.payment_dollar,
      show_purchase_price: pos?.show_purchase_price,
      edit_price: pos?.edit_price,
      status: pos?.status,
      posId: pos?.id,
      posName: pos?.name,
      organizationId: pos?.stock?.organization!.id,
      organizationName: pos?.stock?.organization!.name,
      organizationInn: pos?.stock?.organization!.inn,
      stockId: pos?.stock?.id,
      stockAddress: pos?.stock?.address,
      stockName: pos?.stock?.name,
      regionId: pos?.stock?.region?.id,
      regionName: pos?.stock?.region?.name,
      paymentTypes: jsonEncode(pos?.paymentTypes?.map((e) => e.toJson()).toList()));

  static PosManagerDto toDto(Poses posDb) => PosManagerDto(
      id: posDb.id,
      name: posDb.name ?? "",
      position: posDb.position,
      username: posDb.username,
      role: posDb.role,
      pos: PosDto(
          id: posDb.posId ?? 0,
          name: posDb.posName ?? "",
          gnk_id: posDb.gnk_id,
          status: posDb.status,
          enable_no_fiscal_sale: posDb.enable_no_fiscal_sale,
          integration_with_1c: posDb.integration_with_1c,
          manager_sale: posDb.manager_sale,
          payment_dollar: posDb.payment_dollar,
          show_purchase_price: posDb.show_purchase_price,
          edit_price: posDb.edit_price,
          paymentTypes: posDb.paymentTypes != null
              ? (jsonDecode(posDb.paymentTypes!) as List<dynamic>?)
                  ?.map((e) => PaymentTypeDto.fromJson(e))
                  .toList()
              : null,
          stock: StockDto(
              id: posDb.stockId ?? 0,
              name: posDb.stockName ?? "",
              address: posDb.stockAddress,
              region: RegionDto(id: posDb.regionId ?? 0, name: posDb.regionName ?? ""),
              organization: OrganizationDto(
                  id: posDb.organizationId ?? 0,
                  name: posDb.organizationName ?? "",
                  inn: posDb.organizationInn ?? ""))));
}
