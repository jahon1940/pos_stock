import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckSellItem extends StatelessWidget {
  final String? name;
  final String? cnt;
  final String? price;
  final String? vat;
  final String? totalPrice;
  final String? ikpu;
  final String? commitent_tin;
  final String? discount;
  final String? barcode;
  final String? mk;
  final TextStyle? textStyle;
  final TextStyle? textStyleBold;
  final Function()? onTap;

  const CheckSellItem({
    super.key,
    this.name,
    this.barcode,
    this.cnt,
    this.price,
    this.vat,
    this.totalPrice,
    this.ikpu,
    this.commitent_tin,
    this.discount,
    this.mk,
    this.textStyle,
    this.textStyleBold,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name!, style: textStyleBold),
                  Text("$cnt шт. x $price", style: textStyle),
                  Text("${context.tr('vat')}: $vat", style: textStyle),
                  Text("${context.tr('classCode')}: $ikpu", style: textStyle),
                  if (barcode != null && barcode!.isNotEmpty)
                    Text("${context.tr('barcode')}: $barcode", style: textStyle),
                  if (mk != null)
                    Text("mk" ": $mk", style: textStyle),
                ]
              )
            ),
            Expanded(child: Text(totalPrice!, textAlign: TextAlign.right,style: textStyle))
          ]
        )
      ),
    );
  }
}
