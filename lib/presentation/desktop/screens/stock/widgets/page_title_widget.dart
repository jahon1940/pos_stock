import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/text_style_extension.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/back_button_widget.dart';

import '../../../../../core/constants/app_utils.dart';
import '../../../../../core/styles/text_style.dart';

class PageTitleWidget extends StatelessWidget {
  const PageTitleWidget({
    super.key,
    required this.label,
    this.canPop = false,
  });

  final String label;
  final bool canPop;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        width: double.infinity,
        height: 60,
        padding: AppUtils.kPaddingAll6,
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: AppUtils.kBorderRadius12,
          boxShadow: [BoxShadow(color: context.theme.dividerColor, blurRadius: 3)],
        ),
        child: Row(
          children: [
            /// back button
            if (canPop) const BackButtonWidget(),
            if (canPop) AppUtils.kGap6,

            /// label
            AppUtils.kGap6,
            Text(
              label,
              style: AppTextStyles.boldType18.withColorPrimary500,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      );
}
