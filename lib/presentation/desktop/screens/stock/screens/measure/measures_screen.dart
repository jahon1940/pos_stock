import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/dictionary.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/operation_result_dialog.dart';

import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../app/di.dart';
import '../../widgets/table_title_widget.dart';
import 'cubit/measure_cubit.dart';
import 'widgets/create_measure_dialog.dart';
import 'widgets/measure_item_widget.dart';

class MeasuresScreen extends StatelessWidget {
  const MeasuresScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<MeasureCubit>()..getMeasures(),
        child: Scaffold(
          body: Padding(
            padding: AppUtils.kPaddingAll10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// header
                Container(
                  padding: AppUtils.kPaddingAll6,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: AppUtils.kBorderRadius12,
                    boxShadow: [BoxShadow(color: context.theme.dividerColor, blurRadius: 3)],
                  ),
                  child: Row(
                    children: [
                      const Spacer(),

                      ///
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary800,
                          minimumSize: Size(context.width * .15, 48),
                        ),
                        onPressed: () => showDialog<bool?>(
                          context: context,
                          builder: (_) => const Center(child: CreateMeasureDialog()),
                        ).then((isSuccess) {
                          if (isSuccess.isNotNull) {
                            showDialog(
                              context: context,
                              builder: (context) => OperationResultDialog(
                                label: isSuccess! ? 'Единица измерения создан' : null,
                                isError: !isSuccess,
                              ),
                            );
                          }
                        }),
                        child: Text(
                          'Создать измерения',
                          style: TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),

                /// body
                AppUtils.kMainObjectsGap,
                Expanded(
                  child: CustomBox(
                    padding: AppUtils.kPaddingAll12.withB0,
                    child: Column(
                      children: [
                        ///
                        TableTitleWidget(
                          titles: ['ID', context.tr(Dictionary.name), 'Действия'],
                          columnWidths: {
                            0: const FlexColumnWidth(2),
                            1: const FlexColumnWidth(6),
                            2: const FlexColumnWidth(2),
                          },
                        ),

                        ///
                        AppUtils.kGap12,
                        BlocBuilder<MeasureCubit, MeasureState>(
                          builder: (context, state) => Expanded(
                            child: state.status.isLoading
                                ? const Center(child: CupertinoActivityIndicator())
                                : (state.measures?.results ?? []).isEmpty
                                    ? Center(child: Text(context.tr(Dictionary.not_found)))
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        padding: AppUtils.kPaddingB12,
                                        itemCount: state.measures?.results.length ?? 0,
                                        separatorBuilder: (_, __) => AppUtils.kGap12,
                                        itemBuilder: (context, index) => MeasureItemWidget(
                                          country: state.measures!.results[index],
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
