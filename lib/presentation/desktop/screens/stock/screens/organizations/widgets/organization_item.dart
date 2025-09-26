import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';

import '../../../../../../../data/dtos/company_dto.dart';
import '../../../bloc/stock_bloc.dart';

class OrganizationItem extends StatelessWidget {
  const OrganizationItem({
    super.key,
    required this.organization,
    required this.columnWidths,
  });

  final CompanyDto organization;
  final Map<int, TableColumnWidth> columnWidths;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: columnWidths,
        onTap: () async {
          context.read<StockBloc>().add(StockEvent.getStocks(organization.id));
          await router.push(StocksRoute(organizations: organization));
        },
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: AppUtils.kPaddingAll12,
              child: Text(organization.id.toString()),
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: AppUtils.kPaddingAll12,
              child: Text(organization.name ?? ''),
            ),
          ),
          SizedBox(
            width: 50,
            // child: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: IconButton.filled(
            //     onPressed: onDelete,
            //     icon: Icon(Icons.delete),
            //     color: AppColors.white,
            //     style: ButtonStyle(
            //       backgroundColor: WidgetStatePropertyAll(Colors.red),
            //     ),
            //   ),
            // ),
          )
        ],
      );
}
