import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';

import 'cubit/add_stock_cubit.dart';

class AddStockDialog extends StatelessWidget {
  const AddStockDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddStockCubit>()..init(),
      child: BlocConsumer<AddStockCubit, AddStockState>(
        builder: (context, state) {
          final cubit = context.read<AddStockCubit>();
          return DecoratedBox(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Указанный курс'),
                      SizedBox(
                        width: 12,
                      ),
                      Text(''),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 250,
                    child: AppTextField(
                      hint: 'Введите курс',
                      onChange: (p0) => cubit.changeCurrency(p0),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.secondary200),
                          child: Text(
                            'Отменить',
                            style: AppTextStyles.boldType14
                                .copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      GestureDetector(
                        onTap: state.status == StateStatus.loading
                            ? null
                            : () => cubit.saveNewCurrency(),
                        behavior: HitTestBehavior.opaque,
                        child: state.status == StateStatus.loading
                            ? CupertinoActivityIndicator(
                                color: AppColors.white,
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.primary500),
                                child: Text(
                                  'Сохранить',
                                  style: AppTextStyles.boldType14
                                      .copyWith(color: AppColors.white),
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
        listener: (BuildContext context, AddStockState state) {
          if (state.status != StateStatus.success) return;
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
