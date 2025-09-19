import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/money_formatter.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';

import 'cubit/cash_in_out_cubit.dart';

class CashInOut extends HookWidget {
  const CashInOut({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final priceController = TextEditingController();
    final commentController = TextEditingController();

    final hasPriceError = useState(false);
    final hasCommentError = useState(false);

    ThemeData themeData = Theme.of(context);

    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeData.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr(type), style: AppTextStyles.boldType14),
          AppSpace.vertical12,
          // Поле суммы
          AppTextField(
            width: 350,
            fieldController: priceController,
            label: context.tr('sum'),
            hint: 'Введите сумму',
            enabledBorderColor:
                hasPriceError.value ? AppColors.error500 : AppColors.stroke,
            enabledBorderWith: 1,
            textInputType: TextInputType.number,
            textInputFormatter: [MoneyFormatter()],
            onChange: (value) {
              if (value.isNotEmpty) hasPriceError.value = false;
            },
          ),
          if (hasPriceError.value)
            const Padding(
              padding: EdgeInsets.only(top: 4, left: 4),
              child: Text(
                'Это поле обязательно',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          AppSpace.vertical12,

          // Поле комментария
          AppTextField(
            width: 350,
            fieldController: commentController,
            label: 'Комментарий',
            hint: 'Введите комментарий',
            enabledBorderColor:
                hasCommentError.value ? AppColors.error500 : AppColors.stroke,
            enabledBorderWith: 1,
            textInputType: TextInputType.text,
            onChange: (value) {
              if (value.isNotEmpty) hasCommentError.value = false;
            },
          ),
          if (hasCommentError.value)
            const Padding(
              padding: EdgeInsets.only(top: 4, left: 4),
              child: Text(
                'Это поле обязательно',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          AppSpace.vertical12,

          SizedBox(
            width: 350,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Кнопка отмены
                Expanded(
                  child: MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // ← округление
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: AppColors.error500,
                    child: Text(
                      context.tr("cancel"),
                      style:
                          AppTextStyles.mType16.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                AppSpace.horizontal12,

                // Кнопка сохранить
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      final isPriceEmpty = priceController.text.trim().isEmpty;
                      final isCommentEmpty =
                          commentController.text.trim().isEmpty;

                      hasPriceError.value = isPriceEmpty;
                      hasCommentError.value = isCommentEmpty;

                      if (isPriceEmpty || isCommentEmpty) return;

                      final amount = FormatterService()
                          .strimmerDouble(priceController.text)
                          .toInt();
                      context.read<CashInOutCubit>().saveReceipt(
                          amount, commentController.text.trim(), type, context);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // ← округление
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: themeData.primaryColor,
                    child: Text(
                      context.tr("save"),
                      style:
                          AppTextStyles.mType16.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
