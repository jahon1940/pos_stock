import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/styles/colors.dart';

import '../../../../core/styles/text_style.dart';

class ReceiptText extends StatelessWidget {
  final String titleZ;
  final String infoZ;

  const ReceiptText({super.key, required this.titleZ, required this.infoZ});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(titleZ, style: AppTextStyles.mType12.copyWith(color: AppColors.secondary900))),
              Expanded(child: Text(infoZ, textAlign: TextAlign.right, style: AppTextStyles.mType12.copyWith(color: AppColors.secondary900)))
            ]
        )
    );
  }
}