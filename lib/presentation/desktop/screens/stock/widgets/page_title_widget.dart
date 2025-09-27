import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/text_style_extension.dart';

import '../../../../../core/constants/app_utils.dart';
import '../../../../../core/styles/colors.dart';
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
            if (canPop)
              Container(
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: AppUtils.kBorderRadius12,
                  boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                child: Center(
                  child: InkWell(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            /// label
            AppUtils.kGap12,
            Text(
              label,
              style: AppTextStyles.boldType18.withColorPrimary500,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      );
}
