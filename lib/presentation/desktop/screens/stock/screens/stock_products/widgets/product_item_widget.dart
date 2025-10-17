import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/confirm_dialog.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/product_dto.dart';
import '../../../../../dialogs/prouct_detail/product_detail_dialog.dart';
import '../../../../search/cubit/search_bloc.dart';
import '../create_product_screen.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({
    super.key,
    required this.navigationKey,
    required this.product,
  });

  final GlobalKey<NavigatorState> navigationKey;
  final ProductDto product;

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
        builder: (context) => ProductDetailDialog(productDto: product),
      ),
      children: [
        /// name and vendor code
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

        /// category name
        _item(
          Text(
            product.category?.name ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.2),
          ),
        ),

        /// supplier name
        _item(
          Text(
            product.supplier?.name ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.2),
          ),
        ),

        /// quantity
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

        /// purchase price
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

        /// price
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
              ///
              CustomSquareIconBtn(
                Icons.edit,
                onTap: () => _push(product),
              ),
              CustomSquareIconBtn(
                Icons.delete,
                backgrounColor: AppColors.error500,
                onTap: () async => showDialog(
                  context: context,
                  builder: (dialocContext) => ConfirmDialog(
                    label: 'Вы действительно хотите удалить?',
                    onConfirm: () {
                      dialocContext.pop();
                      context.searchBloc.add(DeleteProductEvent(product.id));
                    },
                  ),
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

  void _push(
    ProductDto product,
  ) =>
      navigationKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => CreateProductScreen(product: product),
        ),
      );
}
