import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';

import '../../../../../../../data/dtos/stock_dto.dart';

class StocksList extends StatelessWidget {
  const StocksList(
      {super.key,
      required this.stocks,
      this.onDelete,
      required this.organization});
  final CompanyDto organization;
  final StockDto stocks;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return TableProductItem(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(4),
        2: FlexColumnWidth(1),
      },
      onTap: () async {
        context
            .read<StockBloc>()
            .add(StockEvent.searchSupplies(stocks.id, true));
        await router
            .push(StockRoute(stock: stocks, organization: organization));
      },
      children: [
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              stocks.id.toString(),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              stocks.name ?? '',
            ),
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
}
