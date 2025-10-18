import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'cubit/currency_cubit.dart';

class CurrencyDialog extends StatelessWidget {
  const CurrencyDialog({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<CurrencyCubit>()..init(),
        child: BlocConsumer<CurrencyCubit, CurrencyState>(
          builder: (context, state) {
            final cubit = context.read<CurrencyCubit>();
            return DecoratedBox(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Указанный курс'),
                        const SizedBox(width: 12),
                        Text(state.currency?.priceUzsRate.toString() ?? ''),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 250,
                      child: AppTextField(
                        hint: 'Введите курс',
                        onChange: (p0) => cubit.changeCurrency(p0),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.secondary200),
                            child: Text(
                              'Отменить',
                              style: AppTextStyles.boldType14.copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: state.status == StateStatus.loading ? null : () => cubit.saveNewCurrency(),
                          behavior: HitTestBehavior.opaque,
                          child: state.status == StateStatus.loading
                              ? const CupertinoActivityIndicator(
                                  color: AppColors.white,
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12), color: AppColors.primary500),
                                  child: Text(
                                    'Сохранить',
                                    style: AppTextStyles.boldType14.copyWith(color: AppColors.white),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          listener: (BuildContext context, CurrencyState state) {
            if (state.status != StateStatus.success) return;
            Navigator.pop(context, true);
          },
        ),
      );
}
