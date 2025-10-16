import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../core/constants/app_utils.dart';
import '../../../../../core/styles/colors.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    super.key,
  });

  static const _radius = AppUtils.kBorderRadius12;

  @override
  Widget build(
    BuildContext context,
  ) =>
      SizedBox(
        height: 48,
        width: 48,
        child: Material(
          borderRadius: _radius,
          color: AppColors.primary500,
          child: InkWell(
            onTap: context.pop,
            hoverColor: AppColors.primary400,
            highlightColor: AppColors.primary300,
            splashColor: AppColors.primary300,
            borderRadius: _radius,
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
        ),
      );
}
