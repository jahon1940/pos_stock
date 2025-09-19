import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:hoomo_pos/presentation/desktop/widgets/products/counter_button.dart';
import 'package:hoomo_pos/presentation/desktop/widgets/products/product_text.dart';

class ProductTile extends StatelessWidget {
  ProductTile({
    super.key,
    required this.product,
    this.onTap,
    this.onDelete,
  });

  final ProductDto product;
  final ValueChanged<ProductDto>? onTap;
  final ValueChanged<ProductDto>? onDelete;
  final TextEditingController countController =
      TextEditingController(text: "0.0");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(product),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${context.tr("article")}: ${product.category?.name ?? "dvdfv"}",
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.mType14),
                  Text(product.title ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.mType16)
                ],
              ),
            ),
          ),
          if (onDelete == null) ProductText(text: product.brand?.name ?? ""),
          ProductText(text: product.maxQuantity.toString()),
          ProductText(text: product.packagename ?? ""),
          ProductText(
              text: FormatterService().formatNumber(product.price.toString(),
                  showTyin: false, currencySymbol: product.inCart ?? false),
              alignEnd: true),
          if (onDelete == null)
            Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                      product.inCart ?? false
                          ? Icons.delete_outline
                          : Icons.add_box_outlined,
                      color:
                          product.inCart ?? false ? Colors.red : Colors.green,
                      size: 24),
                  padding: EdgeInsets.zero,
                  hoverColor: Colors.transparent,
                  onPressed: () => product.inCart ?? false
                      ? onDelete?.call(product)
                      : onTap?.call(product),
                )),
          if (onDelete != null)
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CounterButton(
                        onPressed: () => onDelete?.call(product),
                        icon: Icons.remove),
                    Expanded(
                      child: TextField(
                        controller: countController,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.mType14,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hoverColor: Colors.transparent),
                      ),
                    ),
                    CounterButton(
                        onPressed: () => onTap?.call(product), icon: Icons.add),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
