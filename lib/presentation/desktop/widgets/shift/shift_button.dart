import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/cash_in_out/cash_in_out.dart';

import '../../../../core/styles/text_style.dart';

class ShiftButton extends StatelessWidget {
  const ShiftButton({super.key, required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 45,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: type == "cash_in" ? AppColors.success600 : AppColors.error600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor:
              Colors.transparent,
              elevation: 0,
              child: GestureDetector(
                behavior: HitTestBehavior
                    .translucent,
                // Позволяет ловить клики за пределами диалога
                onTap: () =>
                    Navigator.of(context)
                        .pop(),
                // Закрываем диалог при нажатии вне
                child: Align(
                  alignment:
                  Alignment.topCenter,
                  // Размещаем диалог выше
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 50),
                    // Отступ сверху
                    child: GestureDetector(
                      onTap: () {},
                      // Блокируем закрытие при клике на сам диалог
                      child: CashInOut(
                          type: type),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Text(context.tr(type),
            style: AppTextStyles.boldType16),
      ),
    );
  }
}
