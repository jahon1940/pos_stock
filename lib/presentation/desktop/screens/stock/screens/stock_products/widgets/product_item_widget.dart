import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import '../../../../../../../app/router.gr.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../data/dtos/product_dto.dart';
import '../../../../../../../data/dtos/stock_dto.dart';
import '../../../../../dialogs/prouct_detail/product_detail_dialog.dart';
import '../../../../search/cubit/search_bloc.dart';
import '../../../widgets/delete_product_widget.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({
    super.key,
    required this.product,
    required this.stock,
    required this.organization,
  });

  final ProductDto product;
  final StockDto stock;
  final CompanyDto organization;

  @override
  Widget build(
    BuildContext context,
  ) {
    final productInStocks = product.stocks.firstOrNull;
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );
    return TableProductItem(
      columnWidths: {
        0: const FlexColumnWidth(6),
        1: const FlexColumnWidth(4),
        2: const FlexColumnWidth(3),
        3: const FlexColumnWidth(3),
        4: const FlexColumnWidth(3),
        5: const FlexColumnWidth(3),
        6: const FlexColumnWidth(3),
      },
      onTap: () => showDialog(
        context: context,
        builder: (context) => Center(
          child: ProductDetailDialog(productDto: product),
        ),
      ),
      children: [
        ///
        _item(
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${context.tr("article")}: ${product.vendorCode ?? 'Не найдено'}",
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
                    ),
                    Text(
                      product.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        ///
        _item(
          Text(
            product.category?.name ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.2),
          ),
        ),

        ///
        _item(
          Text(
            product.supplier?.name ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.2),
          ),
        ),

        ///
        _item(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (productInStocks?.quantity ?? 0) == 0
                    ? 'Нет в наличии'
                    : 'Ост./Резерв: ${productInStocks!.quantity}/${productInStocks.quantityReserve}',
                style: const TextStyle(fontSize: 11),
              ),
              if ((productInStocks?.freeQuantity ?? 0) > 0)
                Text(
                  'Своб. ост : ${productInStocks!.freeQuantity}',
                  style: const TextStyle(fontSize: 11, color: AppColors.success600),
                ),
            ],
          ),
        ),

        ///
        _item(
          SizedBox(
            child: product.price == null
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${currencyFormatter.format(product.purchasePriceDollar).replaceAll('.', ' ')} \$",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const Divider(height: 6),
                      Text(
                        "${currencyFormatter.format(product.purchasePriceUzs).replaceAll('.', ' ')} сум",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        ///
        _item(
          SizedBox(
            child: product.price == null
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${currencyFormatter.format(product.priceDollar).replaceAll('.', ' ')}\$",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const Divider(height: 6),
                      Text(
                        "${currencyFormatter.format(product.price).replaceAll('.', ' ')}сум",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
          ),
        ),

        /// buttons
        _item(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async => router.push(AddProductRoute(
                  product: product,
                  stock: stock,
                  organization: organization,
                )),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary500,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                  ),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final res = await context.showCustomDialog(const DeleteProductWidget());
                  if (res == null) return;
                  context.searchBloc.add(DeleteProduct(product.id));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.error500,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _item(
    Widget child,
  ) =>
      Container(
        height: 60,
        padding: AppUtils.kPaddingH8V4,
        alignment: Alignment.center,
        child: child,
      );
}
