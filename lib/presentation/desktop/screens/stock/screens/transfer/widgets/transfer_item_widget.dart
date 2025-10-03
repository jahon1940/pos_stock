import 'package:flutter/material.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/utils/date_parser.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import '../../../../../../../app/router.gr.dart';
import '../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../../../data/dtos/transfers/transfer_dto.dart';

class TransfersItemWidget extends StatelessWidget {
  const TransfersItemWidget({
    super.key,
    required this.admission,
    this.onDelete,
    required this.stock,
    required this.organization,
  });

  final StockDto stock;
  final TransferDto admission;
  final VoidCallback? onDelete;
  final CompanyDto organization;

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
        onTap: () => router.push(AddTransferRoute(
          transferBloc: context.transferBloc,
          transfer: admission,
          stock: stock,
          organization: organization,
        )),
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(admission.id.toString()),
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
              child: Center(
                child: Text("${admission.supplyProductsCount ?? ''}"),
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
