import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/utils/date_parser.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../data/dtos/transfers/transfer_dto.dart';

class TransferItemWidget extends StatelessWidget {
  const TransferItemWidget({
    super.key,
    required this.transfer,
    this.onDelete,
    required this.stock,
    required this.organization,
    required this.onTap,
  });

  final StockDto stock;
  final TransferDto transfer;
  final VoidCallback? onDelete;
  final CompanyDto organization;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        onTap: onTap,
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(transfer.id.toString()),
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(DateParser.dayMonthHString(transfer.createdAt, 'ru')),
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text("${transfer.supplyProductsCount ?? ''}"),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
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
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
}
