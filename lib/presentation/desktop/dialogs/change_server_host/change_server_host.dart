import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';

import '../../../../core/mixins/secure_storage_mixin.dart';


class ChangeServerHost extends HookWidget with SecureStorageMixin{
  ChangeServerHost({super.key});

  @override
  Widget build(BuildContext context) {
    final hostController = TextEditingController(text: NetworkConstants.baseHostName);

    final hasHostError = useState(false);

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
          AppSpace.vertical12,
          // Поле суммы
          // Поле комментария
          AppTextField(
            width: 350,
            fieldController: hostController,
            label: 'Названия хоста',
            hint: 'Введите названия хоста',
            enabledBorderColor:
            hasHostError.value ? AppColors.error500 : AppColors.stroke,
            enabledBorderWith: 1,
            textInputType: TextInputType.text,
            onChange: (value) {
              if (value.isNotEmpty) hasHostError.value = false;
            },
          ),
          if (hasHostError.value)
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
                    onPressed: () async {
                      final isHostEmpty =
                          hostController.text.trim().isEmpty;

                      hasHostError.value = isHostEmpty;

                      if (isHostEmpty) return;

                      NetworkConstants.baseHostName = hostController.text;
                      await writeData(SecureStorageKeys.baseHostName, hostController.text);
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
