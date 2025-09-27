import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../core/constants/app_utils.dart';
import '../../../../../core/styles/colors.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      InkWell(
        onTap: () => context.pop(),
        child: Container(
          width: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary500,
            borderRadius: AppUtils.kBorderRadius12,
            boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
          ),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
      );
}
