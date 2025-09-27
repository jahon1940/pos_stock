import 'package:flutter/material.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';

import '../../../../../../../data/dtos/stock_dto.dart';

class StockItemWidget extends StatelessWidget {
  const StockItemWidget({
    super.key,
    required this.stocks,
    required this.organization,
    required this.columnWidths,
  });

  final CompanyDto organization;
  final StockDto stocks;
  final Map<int, TableColumnWidth> columnWidths;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: columnWidths,
        onTap: () async {
          context.stockBloc.add(StockEvent.searchSupplies(stocks.id, true));
          await router.push(StockRoute(stock: stocks, organization: organization));
        },
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(stocks.id.toString()),
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(stocks.name),
            ),
          ),
          SizedBox(width: 50)
        ],
      );
}
