import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';

class DeleteProductWidget extends StatelessWidget {
  const DeleteProductWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width / 3),
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Вы действительно хотите удалить?',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.boldType24,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 160,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.success500),
                        child: Text(
                          'Нет',
                          style: AppTextStyles.boldType18.copyWith(color: AppColors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 160,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.error500),
                        child: Text(
                          'Да',
                          style: AppTextStyles.boldType18.copyWith(color: AppColors.white),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24)
              ],
            ),
          ),
        ),
      );
}
