import 'package:flutter/material.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/utils/date_parser.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';

import '../../../../../../../../../core/constants/spaces.dart';
import '../../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../../data/dtos/stock_dto.dart';

class SuppliesList extends StatelessWidget {
  const SuppliesList({
    super.key,
    required this.admission,
    this.onDelete,
    required this.stock,
    required this.organization,
  });

  final StockDto stock;
  final SupplyDto admission;
  final VoidCallback? onDelete;
  final CompanyDto organization;

  @override
  Widget build(BuildContext context) {
    return TableProductItem(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
      },
      onTap: () async {
        await router.push(AddSuppliesRoute(supply: admission, stock: stock, organization: organization));
      },
      children: [
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              admission.id.toString(),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(DateParser.dayMonthHString(admission.createdAt, 'ru')),
          ),
        ),
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              admission.supplier?.name ?? '',
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "${admission.supplyProductsCount ?? ''}",
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "${admission.totalPrice ?? ""}",
              ),
            ),
          ),
        ),
        SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                      ),
                      height: 40,
                      width: 40,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.error500,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                      ),
                      height: 40,
                      width: 40,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
