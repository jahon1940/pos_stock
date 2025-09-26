import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/text_style_extension.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/text_style.dart';

class PageTitleWidget extends StatelessWidget {
  const PageTitleWidget({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        width: double.infinity,
        height: 60,
        padding: AppUtils.kPaddingL12,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: AppUtils.kBorderRadius12,
          boxShadow: AppUtils.mainShadow,
        ),
        child: Text(
          label,
          style: AppTextStyles.boldType18.withColorPrimary500,
          textAlign: TextAlign.start,
        ),
      );
}
