import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/custom_square_icon_btn.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/country/country_dto.dart';
import '../../../../../dialogs/operation_result_dialog.dart';
import 'create_country_dialog.dart';

class CountryItemWidget extends StatelessWidget {
  const CountryItemWidget({
    super.key,
    required this.country,
  });

  final CountryDto country;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: {
          0: const FlexColumnWidth(2),
          1: const FlexColumnWidth(6),
          2: const FlexColumnWidth(2),
        },
        onTap: () async {},
        children: [
          _item(
            child: Text('${country.id}'),
          ),
          _item(
            child: Text(country.name ?? ''),
          ),
          _item(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomSquareIconBtn(
                  backgrounColor: AppColors.primary500,
                  Icons.edit,
                  onTap: () => showDialog<bool?>(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.countryBloc,
                      child: CreateCountryDialog(country: country),
                    ),
                  ).then((isSuccess) async {
                    if (isSuccess.isNotNull) {
                      await Future.delayed(Durations.medium1);
                      await showDialog(
                        context: context,
                        builder: (context) => OperationResultDialog(
                          label: isSuccess! ? 'Страна обновлен' : null,
                          isError: !isSuccess,
                        ),
                      );
                    }
                  }),
                ),
                const CustomSquareIconBtn(
                  Icons.delete,
                  backgrounColor: AppColors.error500,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _item({
    required Widget child,
  }) =>
      Padding(
        padding: AppUtils.kPaddingAll10,
        child: child,
      );
}
